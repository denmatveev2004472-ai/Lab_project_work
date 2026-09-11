<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from 'vue'

const API_BASE = import.meta.env.DEV
  ? `${window.location.protocol}//${window.location.hostname}:8000`
  : window.location.origin

const INSTRUMENTS = [
  { id: 'ftir', label: 'ИК-спектроскопия (FTIR)' },
  { id: 'tga', label: 'Термогравиметрия (TGA)' },
  { id: 'dls', label: 'Динамическое светорассеяние (DLS)' },
  { id: 'opt', label: 'Оптический микроскоп' },
  { id: 'confocal', label: 'Конфокальный микроскоп' },
  { id: 'benano', label: 'Динамическое светорассеяние (BeNano)' },
  { id: 'lyophil', label: 'Лиофильная сушка' },
  { id: 'vacuum', label: 'Вакуумный сушильный шкаф' },
]

const selectedInstrument = ref(INSTRUMENTS[0].id)
const weekOffset = ref(0)
const bookings = ref([])
const maintenance = ref([])
const loading = ref(true)
const refreshing = ref(false)
const error = ref('')
const lastUpdated = ref(null)
const showBooking = ref(false)
const saving = ref(false)
const formError = ref('')
const bookingForm = reactive({ date: '', who: '', experiment: '', start: '09:00', duration: 60 })
let refreshTimer
let loadController

function localDate(date) {
  const y = date.getFullYear()
  const m = String(date.getMonth() + 1).padStart(2, '0')
  const d = String(date.getDate()).padStart(2, '0')
  return `${y}-${m}-${d}`
}

function weekDates(offset = 0) {
  const now = new Date()
  now.setHours(0, 0, 0, 0)
  const day = now.getDay() === 0 ? 6 : now.getDay() - 1
  const monday = new Date(now)
  monday.setDate(now.getDate() - day + offset * 7)
  return Array.from({ length: 7 }, (_, index) => {
    const date = new Date(monday)
    date.setDate(monday.getDate() + index)
    return date
  })
}

const days = computed(() => weekDates(weekOffset.value))
const weekLabel = computed(() => {
  const first = days.value[0]
  const last = days.value[6]
  const options = { day: 'numeric', month: 'short' }
  return `${first.toLocaleDateString('ru-RU', options)} — ${last.toLocaleDateString('ru-RU', options)}`
})
const selectedLabel = computed(() => INSTRUMENTS.find(i => i.id === selectedInstrument.value)?.label || '')

function maintenanceFor(instrumentId, dateValue = '') {
  return maintenance.value.find(record => {
    if (record.instrument_id !== instrumentId) return false
    return !dateValue || (dateValue >= record.date_from && dateValue <= record.date_to)
  })
}

function isUnavailable(instrumentId, dateValue) {
  return Boolean(maintenanceFor(instrumentId, dateValue))
}

function bookingsFor(dateValue) {
  return bookings.value
    .filter(item => item.instrumentId === selectedInstrument.value && item.date === dateValue)
    .sort((a, b) => a.startMinutes - b.startMinutes)
}

function formatDay(date) {
  return date.toLocaleDateString('ru-RU', { weekday: 'short', day: '2-digit', month: '2-digit' })
}

function formatClock(date) {
  return date.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' })
}

async function request(path, options = {}, timeout = 10000) {
  const controller = new AbortController()
  const timer = window.setTimeout(() => controller.abort(), timeout)
  if (loadController) loadController.signal.addEventListener('abort', () => controller.abort(), { once: true })
  try {
    const response = await fetch(`${API_BASE}${path}`, { ...options, signal: controller.signal })
    if (!response.ok) {
      const body = await response.text()
      let message = body
      try { message = JSON.parse(body).detail || body } catch {}
      const err = new Error(message || `HTTP ${response.status}`)
      err.status = response.status
      throw err
    }
    return await response.json()
  } catch (err) {
    if (err.name === 'AbortError') throw new Error('Сервер не ответил за 10 секунд')
    throw err
  } finally {
    window.clearTimeout(timer)
  }
}

async function loadSchedule(manual = false) {
  if (loadController) loadController.abort()
  loadController = new AbortController()
  if (manual) refreshing.value = true
  else loading.value = true
  error.value = ''
  try {
    const query = new URLSearchParams({ period: 'week', offset: String(weekOffset.value) })
    const [usage, maintenanceRows] = await Promise.all([
      request(`/api/instrument-usage?${query}`),
      request('/api/instrument-maintenance/all'),
    ])
    bookings.value = (usage.results || []).map(row => {
      const start = new Date(row.start_time)
      const end = new Date(row.end_time)
      return {
        id: row.id,
        instrumentId: row.instrument_id,
        date: localDate(start),
        who: row.username,
        experiment: row.notes || '',
        start: formatClock(start),
        end: formatClock(end),
        startMinutes: start.getHours() * 60 + start.getMinutes(),
      }
    })
    maintenance.value = Array.isArray(maintenanceRows) ? maintenanceRows : (maintenanceRows.results || [])
    lastUpdated.value = new Date()
  } catch (err) {
    error.value = err.message || 'Не удалось загрузить расписание'
  } finally {
    loading.value = false
    refreshing.value = false
  }
}

function changeWeek(offset) {
  weekOffset.value = offset
  loadSchedule()
}

function openBooking(dateValue) {
  if (isUnavailable(selectedInstrument.value, dateValue)) return
  Object.assign(bookingForm, { date: dateValue, who: '', experiment: '', start: '09:00', duration: 60 })
  formError.value = ''
  showBooking.value = true
}

function closeBooking() {
  if (!saving.value) showBooking.value = false
}

async function saveBooking(force = false) {
  if (!bookingForm.who.trim() || !bookingForm.experiment.trim()) {
    formError.value = 'Укажите имя и эксперимент.'
    return
  }
  if (isUnavailable(selectedInstrument.value, bookingForm.date)) {
    formError.value = 'Прибор недоступен в выбранный день.'
    return
  }
  saving.value = true
  formError.value = ''
  try {
    const start = new Date(`${bookingForm.date}T${bookingForm.start}:00`)
    const end = new Date(start)
    end.setMinutes(end.getMinutes() + Number(bookingForm.duration))
    await request('/api/instrument-usage', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        instrument_id: selectedInstrument.value,
        username: bookingForm.who.trim(),
        start_time: `${bookingForm.date}T${bookingForm.start}:00`,
        end_time: `${localDate(end)}T${String(end.getHours()).padStart(2, '0')}:${String(end.getMinutes()).padStart(2, '0')}:00`,
        notes: bookingForm.experiment.trim(),
        force,
      }),
    })
    showBooking.value = false
    await loadSchedule(true)
  } catch (err) {
    if (err.status === 409 && !force) {
      if (window.confirm('Это время пересекается с существующей записью. Всё равно забронировать?')) {
        saving.value = false
        await saveBooking(true)
        return
      }
    } else {
      formError.value = err.message || 'Не удалось сохранить бронирование'
    }
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  loadSchedule()
  refreshTimer = window.setInterval(() => loadSchedule(true), 60000)
})

onBeforeUnmount(() => {
  if (refreshTimer) window.clearInterval(refreshTimer)
  if (loadController) loadController.abort()
})
</script>

<template>
  <div class="schedule-app">
    <header class="topbar">
      <div class="brand">
        <svg class="mark" viewBox="0 0 40 40" aria-label="Лаборатория" role="img">
          <circle cx="20" cy="20" r="18" />
          <path d="M13 27c2.2-4.8 4.5-7.2 7-7.2s4.8 2.4 7 7.2M20 10v10M16 14h8" />
        </svg>
        <div><h1>Расписание лаборатории</h1><p>Бронирование аналитических приборов</p></div>
      </div>
      <button class="refresh" type="button" :disabled="refreshing" @click="loadSchedule(true)">{{ refreshing ? 'Обновление…' : 'Обновить' }}</button>
    </header>

    <main>
      <section class="instrument-panel" aria-labelledby="instrument-title">
        <div class="section-kicker" id="instrument-title">Выберите прибор</div>
        <div class="instrument-list">
          <button v-for="instrument in INSTRUMENTS" :key="instrument.id" type="button" class="instrument-chip" :class="{ active: selectedInstrument === instrument.id, unavailable: maintenanceFor(instrument.id) }" @click="selectedInstrument = instrument.id">
            <span class="status-dot" aria-hidden="true"></span>{{ instrument.label }}<span v-if="maintenanceFor(instrument.id)" class="status-text">Недоступен</span>
          </button>
        </div>
      </section>

      <section class="schedule-card" aria-labelledby="schedule-title">
        <div class="schedule-head"><div><div class="section-kicker">Расписание прибора</div><h2 id="schedule-title">{{ selectedLabel }}</h2></div><span v-if="maintenanceFor(selectedInstrument)" class="maintenance-badge">Прибор временно недоступен</span></div>
        <div v-if="maintenanceFor(selectedInstrument)" class="maintenance-banner" role="status"><strong>Неисправность или техническое обслуживание.</strong><span>{{ maintenanceFor(selectedInstrument)?.reason || 'Причина не указана администратором.' }}</span></div>
        <div class="weekbar"><div class="week-tabs" role="group" aria-label="Выбор недели"><button type="button" :class="{ active: weekOffset === 0 }" @click="changeWeek(0)">Эта неделя</button><button type="button" :class="{ active: weekOffset === 1 }" @click="changeWeek(1)">Следующая неделя</button></div><span class="week-label">{{ weekLabel }}</span></div>

        <div v-if="loading" class="state-panel" aria-live="polite"><div class="skeleton-row" v-for="n in 4" :key="n"><span></span><span></span><span></span></div><p>Загружаем расписание…</p></div>
        <div v-else-if="error" class="state-panel error-state" role="alert"><strong>Расписание не загрузилось</strong><p>{{ error }}</p><button type="button" @click="loadSchedule()">Повторить</button></div>
        <div v-else class="week-grid">
          <article v-for="day in days" :key="localDate(day)" class="day-card" :class="{ blocked: isUnavailable(selectedInstrument, localDate(day)) }">
            <header><span>{{ formatDay(day) }}</span><span v-if="localDate(day) === localDate(new Date())" class="today">Сегодня</span></header>
            <div v-if="isUnavailable(selectedInstrument, localDate(day))" class="blocked-message"><strong>Недоступен</strong><span>{{ maintenanceFor(selectedInstrument, localDate(day))?.reason || 'Техническое обслуживание' }}</span></div>
            <div v-else class="day-content"><div v-for="booking in bookingsFor(localDate(day))" :key="booking.id" class="booking"><time>{{ booking.start }}–{{ booking.end }}</time><strong>{{ booking.who }}</strong><span>{{ booking.experiment }}</span></div><p v-if="!bookingsFor(localDate(day)).length" class="empty-day">Записей нет</p><button type="button" class="book" @click="openBooking(localDate(day))">Забронировать</button></div>
          </article>
        </div>
      </section>
      <p class="updated" aria-live="polite"><span v-if="lastUpdated">Обновлено {{ lastUpdated.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' }) }}</span><span v-else>Данные ещё не загружены</span></p>
    </main>

    <div v-if="showBooking" class="modal-backdrop" @click.self="closeBooking">
      <form class="modal" @submit.prevent="saveBooking()">
        <div class="modal-head"><div><span class="section-kicker">Новая запись</span><h2>{{ selectedLabel }}</h2></div><button class="close" type="button" aria-label="Закрыть" @click="closeBooking">×</button></div>
        <label>Дата<input v-model="bookingForm.date" type="date" required /></label>
        <label>Ваше имя<input v-model="bookingForm.who" type="text" autocomplete="name" required /></label>
        <label>Эксперимент или задача<textarea v-model="bookingForm.experiment" rows="3" required></textarea></label>
        <div class="form-grid"><label>Начало<input v-model="bookingForm.start" type="time" min="08:00" max="19:00" step="900" required /></label><label>Продолжительность<select v-model="bookingForm.duration"><option :value="30">30 минут</option><option :value="60">1 час</option><option :value="90">1,5 часа</option><option :value="120">2 часа</option><option :value="180">3 часа</option><option :value="240">4 часа</option></select></label></div>
        <p v-if="formError" class="form-error" role="alert">{{ formError }}</p>
        <div class="modal-actions"><button type="button" class="secondary" @click="closeBooking">Отмена</button><button type="submit" class="primary" :disabled="saving">{{ saving ? 'Сохранение…' : 'Забронировать' }}</button></div>
      </form>
    </div>
  </div>
</template>

<style>
:root { color-scheme:dark; --bg:#08141c; --surface:#0d1d27; --surface-2:#102631; --line:#24404d; --text:#edf4f6; --muted:#91a7b0; --accent:#7b3ff2; --accent-2:#9b66ff; --danger:#ee786b; --danger-bg:#321f20; --success:#4ec7a0; --shadow:0 18px 50px rgba(0,0,0,.28); --font:'Segoe UI',system-ui,-apple-system,sans-serif; }
* { box-sizing:border-box; } body { margin:0; min-width:320px; min-height:100vh; background:var(--bg); color:var(--text); font-family:var(--font); font-size:16px; } button,input,textarea,select { font:inherit; } button { cursor:pointer; } button:focus-visible,input:focus-visible,textarea:focus-visible,select:focus-visible { outline:2px solid var(--accent-2); outline-offset:3px; }
.schedule-app { width:min(1440px,100%); margin:0 auto; padding:24px clamp(16px,3vw,40px) 56px; }.topbar { display:flex; align-items:center; justify-content:space-between; gap:20px; padding-bottom:22px; border-bottom:1px solid var(--line); }.brand { display:flex; align-items:center; gap:14px; }.mark { width:46px; height:46px; flex:none; color:#66b4e8; fill:none; stroke:currentColor; stroke-width:2; }h1,h2,p { margin:0; }h1 { font-size:clamp(21px,2.5vw,30px); line-height:1.15; }.brand p { margin-top:4px; color:var(--muted); font-size:14px; }
.refresh,.secondary { min-height:44px; padding:0 18px; color:var(--text); background:transparent; border:1px solid var(--line); border-radius:999px; }.refresh:hover,.secondary:hover { background:var(--surface-2); }.instrument-panel { padding:24px 0; }.section-kicker { margin-bottom:10px; color:var(--muted); font-size:12px; font-weight:700; letter-spacing:.08em; text-transform:uppercase; }.instrument-list { display:flex; flex-wrap:wrap; gap:10px; }.instrument-chip { display:flex; align-items:center; gap:8px; min-height:44px; padding:8px 14px; color:var(--text); background:var(--surface); border:1px solid var(--line); border-radius:999px; }.instrument-chip:hover { background:var(--surface-2); }.instrument-chip.active { border-color:#4f8796; background:#12333b; }.instrument-chip.unavailable { border-color:color-mix(in srgb,var(--danger) 55%,var(--line)); }.status-dot { width:8px; height:8px; border-radius:50%; background:var(--success); }.unavailable .status-dot { background:var(--danger); }.status-text { color:var(--danger); font-size:12px; font-weight:700; }
.schedule-card { overflow:hidden; background:var(--surface); border:1px solid var(--line); border-radius:22px; box-shadow:var(--shadow); }.schedule-head { display:flex; align-items:center; justify-content:space-between; gap:16px; padding:22px; }.schedule-head h2 { font-size:clamp(20px,2.3vw,28px); }.maintenance-badge { padding:7px 11px; color:#ffd7d2; background:var(--danger-bg); border:1px solid color-mix(in srgb,var(--danger) 45%,transparent); border-radius:999px; font-size:13px; font-weight:700; }.maintenance-banner { display:flex; gap:8px 14px; flex-wrap:wrap; margin:0 22px 18px; padding:13px 15px; color:#ffd7d2; background:var(--danger-bg); border-radius:10px; }.weekbar { display:flex; align-items:center; justify-content:space-between; gap:16px; padding:14px 22px; border-top:1px solid var(--line); border-bottom:1px solid var(--line); }.week-tabs { display:flex; gap:8px; }.week-tabs button { min-height:44px; padding:0 17px; color:var(--text); background:var(--surface-2); border:1px solid var(--line); border-radius:999px; }.week-tabs button.active { background:var(--accent); border-color:var(--accent); }.week-label { color:var(--muted); font-variant-numeric:tabular-nums; }
.week-grid { display:grid; grid-template-columns:repeat(7,minmax(145px,1fr)); overflow-x:auto; }.day-card { min-height:270px; border-right:1px solid var(--line); }.day-card:last-child { border-right:0; }.day-card > header { display:flex; justify-content:space-between; gap:8px; min-height:51px; padding:14px 12px; background:var(--surface-2); border-bottom:1px solid var(--line); font-size:13px; font-weight:700; text-transform:lowercase; }.today { color:#7fd6ee; }.day-content { display:flex; flex-direction:column; min-height:218px; padding:10px; }.booking { display:grid; gap:3px; margin-bottom:8px; padding:10px; background:#15303b; border:1px solid #28505d; border-radius:10px; }.booking time { color:#8dd9ef; font-size:12px; font-weight:700; font-variant-numeric:tabular-nums; }.booking strong { font-size:14px; }.booking span { color:var(--muted); font-size:13px; line-height:1.35; overflow-wrap:anywhere; }.empty-day { margin:auto; color:var(--muted); font-size:13px; }.book { min-height:44px; margin-top:auto; color:#b6cbd2; background:transparent; border:1px dashed #31515d; border-radius:10px; }.book:hover { color:var(--text); background:var(--surface-2); }.blocked { background:color-mix(in srgb,var(--danger-bg) 45%,var(--surface)); }.blocked-message { display:flex; flex-direction:column; gap:8px; padding:22px 12px; color:#ffd7d2; }.blocked-message span { color:#d7aaa5; font-size:13px; line-height:1.4; }
.state-panel { min-height:320px; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:12px; padding:24px; color:var(--muted); text-align:center; }.skeleton-row { display:grid; grid-template-columns:1fr 1.5fr .8fr; gap:10px; width:min(620px,100%); }.skeleton-row span { height:24px; border-radius:6px; background:linear-gradient(90deg,var(--surface-2),#173542,var(--surface-2)); background-size:200% 100%; animation:shimmer 1.4s infinite; }@keyframes shimmer { to { background-position:-200% 0; } }.error-state strong { color:var(--text); font-size:18px; }.error-state button { min-height:44px; padding:0 18px; color:white; background:var(--accent); border:0; border-radius:10px; }.updated { padding-top:12px; color:var(--muted); font-size:12px; text-align:right; }
.modal-backdrop { position:fixed; inset:0; z-index:10; display:grid; place-items:center; padding:16px; background:rgba(2,8,12,.78); }.modal { width:min(520px,100%); max-height:calc(100vh - 32px); overflow:auto; padding:22px; background:var(--surface); border:1px solid var(--line); border-radius:18px; box-shadow:var(--shadow); }.modal-head { display:flex; justify-content:space-between; gap:16px; margin-bottom:18px; }.modal-head h2 { font-size:20px; }.close { width:44px; height:44px; color:var(--muted); background:transparent; border:1px solid var(--line); border-radius:50%; font-size:25px; }.modal label { display:grid; gap:7px; margin-top:14px; color:var(--muted); font-size:13px; font-weight:700; }.modal input,.modal textarea,.modal select { width:100%; min-height:44px; padding:10px 12px; color:var(--text); background:#091820; border:1px solid var(--line); border-radius:9px; }.modal textarea { resize:vertical; }.form-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; }.form-error { margin-top:12px; color:#ffaaa1; }.modal-actions { display:flex; justify-content:flex-end; gap:10px; margin-top:22px; }.primary { min-height:44px; padding:0 18px; color:white; background:var(--accent); border:0; border-radius:10px; font-weight:700; }.primary:disabled,.refresh:disabled { opacity:.55; cursor:wait; }
@media (max-width:760px) { .schedule-app { padding:16px 12px 40px; }.topbar,.schedule-head,.weekbar { align-items:stretch; flex-direction:column; }.refresh { width:100%; }.instrument-list { flex-wrap:nowrap; overflow-x:auto; padding-bottom:5px; }.instrument-chip { flex:none; max-width:86vw; }.week-tabs { display:grid; grid-template-columns:1fr 1fr; }.week-label { text-align:center; }.week-grid { display:block; overflow:visible; }.day-card { min-height:0; border-right:0; border-bottom:1px solid var(--line); }.day-content { min-height:150px; }.form-grid { grid-template-columns:1fr; } }
@media (prefers-reduced-motion:reduce) { *,*::before,*::after { animation-duration:.01ms !important; animation-iteration-count:1 !important; scroll-behavior:auto !important; } }
</style>

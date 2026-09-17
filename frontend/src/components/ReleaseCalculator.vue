<script setup>
import { ref, reactive, computed } from 'vue'

const API_BASE = import.meta.env.DEV
  ? `${window.location.protocol}//${window.location.hostname}:8000`
  : window.location.origin

function uid() {
  return Math.random().toString(36).slice(2, 9)
}

/* ────────────────────────────────────────────────────────────────────────
   НАВИГАЦИЯ ПО ШАГАМ (чисто визуальная, ничего не блокирует)
   ──────────────────────────────────────────────────────────────────────── */
const steps = [
  { id: 'calib', num: 1, label: 'Калибровка', icon: '📈' },
  { id: 'dilution', num: 2, label: 'Разведение', icon: '🧪' },
  { id: 'samples', num: 3, label: 'Образцы', icon: '🧫' },
  { id: 'export', num: 4, label: 'Экспорт', icon: '📤' }
]
function scrollTo(id) {
  const el = document.getElementById('rc-step-' + id)
  if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

/* ─── Калибровочные кривые (Y = k·X + b, X = концентрация, Y = OD) ─────── */
const curves = ref([
  {
    id: uid(),
    name: 'PBS pH 5',
    wavelength: 423,
    unit: 'mg_ml', // 'mg_ml' | 'mkg_ml'
    manualKB: false,
    kManual: '',
    bManual: '',
    points: [
      { conc: '', od: '' },
      { conc: '', od: '' }
    ]
  }
])

// какие карточки калибровок свёрнуты/развёрнуты (по умолчанию — все открыты)
const curveOpen = reactive({})
function isCurveOpen(id) { return curveOpen[id] !== false }
function toggleCurve(id) { curveOpen[id] = !isCurveOpen(id) }

function addCurve() {
  const id = uid()
  curves.value.push({
    id, name: '', wavelength: '', unit: 'mg_ml',
    manualKB: false, kManual: '', bManual: '',
    points: [{ conc: '', od: '' }, { conc: '', od: '' }]
  })
  curveOpen[id] = true
}
function removeCurve(id) {
  curves.value = curves.value.filter(c => c.id !== id)
  samples.value.forEach(s => { if (s.curveId === id) s.curveId = '' })
}
function addPoint(curve) { curve.points.push({ conc: '', od: '' }) }
function removePoint(curve, idx) { if (curve.points.length > 2) curve.points.splice(idx, 1) }

function linreg(pts) {
  const valid = pts.filter(p => p.conc !== '' && p.od !== '' && !isNaN(Number(p.conc)) && !isNaN(Number(p.od)))
    .map(p => ({ x: Number(p.conc), y: Number(p.od) }))
  const n = valid.length
  if (n < 2) return { k: null, b: null, r2: null, n }
  const sumX = valid.reduce((s, p) => s + p.x, 0)
  const sumY = valid.reduce((s, p) => s + p.y, 0)
  const sumXY = valid.reduce((s, p) => s + p.x * p.y, 0)
  const sumXX = valid.reduce((s, p) => s + p.x * p.x, 0)
  const denom = n * sumXX - sumX * sumX
  if (denom === 0) return { k: null, b: null, r2: null, n }
  const k = (n * sumXY - sumX * sumY) / denom
  const b = (sumY - k * sumX) / n
  const meanY = sumY / n
  const ssTot = valid.reduce((s, p) => s + (p.y - meanY) ** 2, 0)
  const ssRes = valid.reduce((s, p) => s + (p.y - (k * p.x + b)) ** 2, 0)
  const r2 = ssTot === 0 ? 1 : 1 - ssRes / ssTot
  return { k, b, r2, n }
}

function curveStats(curve) {
  if (curve.manualKB) {
    const k = Number(curve.kManual)
    const b = Number(curve.bManual)
    return { k: isNaN(k) ? null : k, b: isNaN(b) ? null : b, r2: null, n: null }
  }
  return linreg(curve.points)
}

function fmt(v, digits = 4) {
  if (v === null || v === undefined || isNaN(v)) return '—'
  return Number(v).toFixed(digits)
}

// SVG-график калибровочной прямой
function calibrationChart(curve) {
  const stats = curveStats(curve)
  const pts = curve.points
    .filter(p => p.conc !== '' && p.od !== '' && !isNaN(Number(p.conc)) && !isNaN(Number(p.od)))
    .map(p => ({ x: Number(p.conc), y: Number(p.od) }))
  const W = 320, H = 160, PAD = 28
  if (!pts.length) return { pts: [], line: '', W, H, axisX: '', axisY: '' }
  const xs = pts.map(p => p.x); const ys = pts.map(p => p.y)
  let xMin = Math.min(0, ...xs); let xMax = Math.max(...xs) || 1
  let yMin = Math.min(0, ...ys); let yMax = Math.max(...ys) || 1
  if (xMax === xMin) xMax = xMin + 1
  if (yMax === yMin) yMax = yMin + 1
  const sx = x => PAD + ((x - xMin) / (xMax - xMin)) * (W - 2 * PAD)
  const sy = y => H - PAD - ((y - yMin) / (yMax - yMin)) * (H - 2 * PAD)
  const screenPts = pts.map(p => ({ cx: sx(p.x), cy: sy(p.y) }))
  let line = ''
  if (stats.k !== null && stats.b !== null) {
    const x1 = xMin, x2 = xMax
    const y1 = stats.k * x1 + stats.b
    const y2 = stats.k * x2 + stats.b
    line = `M ${sx(x1)} ${sy(y1)} L ${sx(x2)} ${sy(y2)}`
  }
  return { pts: screenPts, line, W, H, xLabel: `${fmt(xMin, 2)} … ${fmt(xMax, 2)}`, yLabel: `${fmt(yMin, 2)} … ${fmt(yMax, 2)}` }
}

/* ─── Разведение: два метода расчёта кратности ───────────────────────── */
const dilutionOpen = ref(true)
const dilutionHelper = reactive({
  mode: 'ratio', // 'ratio' | 'volume'
  ratioSample: 1,
  ratioDiluent: 1,
  aliquot: 20,
  totalVolume: 1000
})
const dilutionHelperResult = computed(() => {
  if (dilutionHelper.mode === 'ratio') {
    const a = Number(dilutionHelper.ratioSample) || 0
    const d = Number(dilutionHelper.ratioDiluent) || 0
    if (a <= 0) return null
    return (a + d) / a
  }
  const al = Number(dilutionHelper.aliquot) || 0
  const tot = Number(dilutionHelper.totalVolume) || 0
  if (al <= 0) return null
  return tot / al
})

/* ─── Образцы (несколько одновременно) ────────────────────────────────── */
const samples = ref([
  {
    id: uid(),
    name: '',
    curveId: curves.value[0]?.id || '',
    totalLoadedMg: '',
    volumeMl: '',
    rows: [
      { time: 1, od1: '', od2: '', od3: '', dilution: 1 },
      { time: 24, od1: '', od2: '', od3: '', dilution: 1 }
    ]
  }
])

const sampleOpen = reactive({})
function isSampleOpen(id) { return sampleOpen[id] !== false }
function toggleSample(id) { sampleOpen[id] = !isSampleOpen(id) }

function addSample() {
  const id = uid()
  samples.value.push({
    id, name: '', curveId: curves.value[0]?.id || '', totalLoadedMg: '', volumeMl: '',
    rows: [{ time: '', od1: '', od2: '', od3: '', dilution: 1 }]
  })
  sampleOpen[id] = true
}
function removeSample(id) { samples.value = samples.value.filter(s => s.id !== id) }
function addRow(sample) {
  const lastTime = sample.rows.length ? Number(sample.rows[sample.rows.length - 1].time) || 0 : 0
  sample.rows.push({ time: lastTime + 24 || '', od1: '', od2: '', od3: '', dilution: 1 })
}
function removeRow(sample, idx) { if (sample.rows.length > 1) sample.rows.splice(idx, 1) }

const palette = ['#0f7c82', '#7c3aed', '#d97706', '#dc2626', '#2563eb', '#16a34a', '#db2777', '#0891b2']

function computeSampleResults(sample) {
  const curve = curves.value.find(c => c.id === sample.curveId)
  const stats = curve ? curveStats(curve) : { k: null, b: null }
  const volume = Number(sample.volumeMl) || 0
  const totalLoaded = Number(sample.totalLoadedMg) || 0
  let cumulative = 0
  return sample.rows.map(row => {
    const odVals = [row.od1, row.od2, row.od3].filter(v => v !== '' && v !== null && !isNaN(Number(v))).map(Number)
    const odMean = odVals.length ? odVals.reduce((a, b) => a + b, 0) / odVals.length : null
    const dilution = Number(row.dilution) || 1
    let concCurveUnits = (odMean !== null && stats.k) ? (odMean - stats.b) / stats.k : null
    if (concCurveUnits !== null && concCurveUnits < 0) concCurveUnits = 0
    const concDiluted = concCurveUnits !== null ? concCurveUnits * dilution : null
    const concMgMl = concDiluted !== null ? (curve?.unit === 'mkg_ml' ? concDiluted / 1000 : concDiluted) : null
    const massMg = concMgMl !== null ? concMgMl * volume : null
    const percentInSolution = (massMg !== null && totalLoaded > 0) ? (massMg / totalLoaded) * 100 : null
    if (percentInSolution !== null) cumulative += percentInSolution
    const percentRelease = percentInSolution !== null ? cumulative : null
    const percentRemaining = percentRelease !== null ? 100 - percentRelease : null
    return {
      time: row.time, odMean, concMgMl, massMg,
      percentInSolution, percentRemaining, percentRelease
    }
  })
}

const samplesWithResults = computed(() => samples.value.map(s => ({
  sample: s,
  results: computeSampleResults(s),
  curveName: curves.value.find(c => c.id === s.curveId)?.name || '—'
})))

// последняя точка релиза — для свёрнутой карточки образца и для "статуса" в шаге 3
function lastRelease(results) {
  const withVal = results.filter(r => r.percentRelease !== null)
  return withVal.length ? withVal[withVal.length - 1].percentRelease : null
}

// Мини-график релиза для одного образца
function releaseChart(results, color) {
  const W = 300, H = 140, PAD = 26
  const pts = results.filter(r => r.percentRelease !== null && r.time !== '' && !isNaN(Number(r.time)))
    .map(r => ({ x: Number(r.time), y: r.percentRelease }))
  if (!pts.length) return { path: '', points: [], W, H, color }
  const xMax = Math.max(...pts.map(p => p.x), 1)
  const yMax = Math.max(...pts.map(p => p.y), 10)
  const sx = x => PAD + (x / xMax) * (W - 2 * PAD)
  const sy = y => H - PAD - (y / yMax) * (H - 2 * PAD)
  const screenPts = pts.map(p => ({ cx: sx(p.x), cy: sy(p.y) }))
  const path = 'M ' + screenPts.map(p => `${p.cx} ${p.cy}`).join(' L ')
  return { path, points: screenPts, W, H, color, xMax, yMax }
}

// Общий сравнительный график по всем образцам
const combinedChart = computed(() => {
  const W = 520, H = 220, PAD = 34
  const series = samplesWithResults.value.map((sw, idx) => {
    const pts = sw.results.filter(r => r.percentRelease !== null && r.time !== '' && !isNaN(Number(r.time)))
      .map(r => ({ x: Number(r.time), y: r.percentRelease }))
    return { name: sw.sample.name || `Образец ${idx + 1}`, color: palette[idx % palette.length], pts }
  }).filter(s => s.pts.length)
  if (!series.length) return { series: [], W, H }
  const allX = series.flatMap(s => s.pts.map(p => p.x))
  const allY = series.flatMap(s => s.pts.map(p => p.y))
  const xMax = Math.max(...allX, 1)
  const yMax = Math.max(...allY, 10, 100)
  const sx = x => PAD + (x / xMax) * (W - 2 * PAD)
  const sy = y => H - PAD - (y / yMax) * (H - 2 * PAD)
  const withPaths = series.map(s => ({
    ...s,
    path: 'M ' + s.pts.map(p => `${sx(p.x)} ${sy(p.y)}`).join(' L '),
    lastPoint: s.pts.length ? { cx: sx(s.pts[s.pts.length - 1].x), cy: sy(s.pts[s.pts.length - 1].y) } : null
  }))
  return { series: withPaths, W, H, xMax, yMax }
})

/* ─── Экспорт ───────────────────────────────────────────────────────── */
const exporting = ref(false)
const exportError = ref('')

async function exportExcel() {
  exportError.value = ''
  exporting.value = true
  try {
    const firstSample = samples.value[0]
    const payload = {
      loading: {
        percent_loaded: null,
        encapsulated_mass_mg: firstSample ? Number(firstSample.totalLoadedMg) || null : null
      },
      release_profiles: samplesWithResults.value.map(sw => ({
        solvent: `${sw.sample.name || 'Образец'} — ${sw.curveName}`,
        rows: sw.results.map(r => ({
          time: r.time,
          od_mean: r.odMean !== null ? Number(r.odMean.toFixed(4)) : null,
          concentration_mg_ml: r.concMgMl !== null ? Number(r.concMgMl.toFixed(4)) : null,
          mass_mg: r.massMg !== null ? Number(r.massMg.toFixed(4)) : null,
          percent_in_solution: r.percentInSolution !== null ? Number(r.percentInSolution.toFixed(2)) : null,
          percent_remaining: r.percentRemaining !== null ? Number(r.percentRemaining.toFixed(2)) : null,
          percent_release: r.percentRelease !== null ? Number(r.percentRelease.toFixed(2)) : null
        }))
      }))
    }
    const r = await fetch(`${API_BASE}/api/experiments/release/export-excel`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })
    if (!r.ok) throw new Error(await r.text())
    const blob = await r.blob()
    const link = document.createElement('a')
    link.href = URL.createObjectURL(blob)
    link.download = 'release_results.xlsx'
    link.click()
    URL.revokeObjectURL(link.href)
  } catch (e) {
    exportError.value = 'Ошибка экспорта в Excel: ' + String(e.message || e)
  } finally {
    exporting.value = false
  }
}

function csvEscape(v) {
  if (v === null || v === undefined) return ''
  const s = String(v)
  return /[;\n"]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s
}

function exportFullCsv() {
  const lines = []
  lines.push('=== КАЛИБРОВОЧНЫЕ КРИВЫЕ ===')
  curves.value.forEach(curve => {
    const stats = curveStats(curve)
    lines.push(`Кривая;${csvEscape(curve.name)};λ=${curve.wavelength} нм;единица=${curve.unit === 'mkg_ml' ? 'мкг/мл' : 'мг/мл'}`)
    lines.push(`k;${fmt(stats.k, 5)};b;${fmt(stats.b, 5)};R2;${fmt(stats.r2, 4)}`)
    lines.push('Концентрация;OD')
    curve.points.forEach(p => lines.push(`${csvEscape(p.conc)};${csvEscape(p.od)}`))
    lines.push('')
  })
  lines.push('=== ОБРАЗЦЫ И РЕЗУЛЬТАТЫ РЕЛИЗА ===')
  samplesWithResults.value.forEach(sw => {
    lines.push(`Образец;${csvEscape(sw.sample.name)};Среда;${csvEscape(sw.curveName)};Загружено мг;${csvEscape(sw.sample.totalLoadedMg)};Объём мл;${csvEscape(sw.sample.volumeMl)}`)
    lines.push('Время ч;OD1;OD2;OD3;Разведение;OD среднее;Конц. мг/мл;Масса мг;% в растворе;% оставшийся;% релиза')
    sw.sample.rows.forEach((row, idx) => {
      const res = sw.results[idx]
      lines.push([
        csvEscape(row.time), csvEscape(row.od1), csvEscape(row.od2), csvEscape(row.od3), csvEscape(row.dilution),
        fmt(res.odMean, 4), fmt(res.concMgMl, 4), fmt(res.massMg, 4),
        fmt(res.percentInSolution, 2), fmt(res.percentRemaining, 2), fmt(res.percentRelease, 2)
      ].join(';'))
    })
    lines.push('')
  })
  const csv = '\uFEFF' + lines.join('\n')
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8' })
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = 'release_full_data.csv'
  link.click()
  URL.revokeObjectURL(link.href)
}
</script>

<template>
  <div class="experiment-card release-calc">
    <div class="section-title">⚗️ Расчёт релиза (загрузка / высвобождение)</div>

    <!-- ═══ ПОШАГОВАЯ ШПАРГАЛКА + НАВИГАЦИЯ ═══ -->
    <div class="rc-guide">
      <div class="rc-guide-title">Как этим пользоваться — 4 шага</div>
      <div class="rc-guide-steps">
        <button v-for="st in steps" :key="st.id" class="rc-guide-step" @click="scrollTo(st.id)">
          <span class="rc-step-badge">{{ st.num }}</span>
          <span class="rc-step-icon">{{ st.icon }}</span>
          <span class="rc-step-label">{{ st.label }}</span>
        </button>
      </div>
      <ol class="rc-guide-list">
        <li><strong>Калибровка</strong> — для каждой среды (вода, PBS, SIF…) внесите точки «концентрация → OD» и получите k и b.</li>
        <li><strong>Разведение</strong> (по желанию) — посчитайте кратность разведения, если разбавляли пробу перед измерением.</li>
        <li><strong>Образцы</strong> — заведите образец, привяжите его к нужной калибровке, впишите OD по времени — процент релиза считается сам.</li>
        <li><strong>Экспорт</strong> — скачайте готовую таблицу в Excel или CSV.</li>
      </ol>
    </div>

    <!-- ═══ ШАГ 1 · КАЛИБРОВОЧНЫЕ КРИВЫЕ ═══ -->
    <div id="rc-step-calib" class="rc-step rc-step-calib">
      <div class="rc-step-header">
        <span class="rc-step-badge rc-step-badge-lg">1</span>
        <div>
          <div class="group-title">Калибровочные кривые</div>
          <div class="rc-step-sub">Формула: Y = k·X + b, где X — концентрация, Y — оптическая плотность (OD)</div>
        </div>
        <button class="btn btn-tiny rc-add-btn" @click="addCurve">+ Добавить кривую</button>
      </div>

      <div v-for="curve in curves" :key="curve.id" class="rc-card rc-card-calib">
        <div class="rc-card-top">
          <button class="rc-collapse-btn" @click="toggleCurve(curve.id)">
            {{ isCurveOpen(curve.id) ? '▾' : '▸' }}
          </button>
          <input v-model="curve.name" type="text" placeholder="Название среды, например: PBS pH 5" class="rc-name-input" />
          <input v-model="curve.wavelength" type="number" placeholder="λ, нм" class="rc-small-input" />
          <select v-model="curve.unit" class="rc-small-input">
            <option value="mg_ml">мг/мл</option>
            <option value="mkg_ml">мкг/мл</option>
          </select>
          <button v-if="curves.length > 1" class="icon-btn" title="Удалить кривую" @click="removeCurve(curve.id)">🗑️</button>
        </div>

        <!-- свёрнутый вид: только итоговая формула -->
        <div v-if="!isCurveOpen(curve.id)" class="rc-collapsed-summary">
          <template v-if="curveStats(curve).k !== null">
            <span class="rc-formula">Y = {{ fmt(curveStats(curve).k, 3) }}·X {{ curveStats(curve).b >= 0 ? '+' : '−' }} {{ fmt(Math.abs(curveStats(curve).b), 4) }}</span>
            <span v-if="curveStats(curve).r2 !== null" class="muted">R² = {{ fmt(curveStats(curve).r2, 4) }}</span>
          </template>
          <span v-else class="muted">Кривая не рассчитана — раскройте карточку и внесите точки.</span>
        </div>

        <template v-else>
          <label class="rc-checkbox-row">
            <input type="checkbox" v-model="curve.manualKB" />
            Ввести k и b вручную (если уже посчитаны в Excel/Origin)
          </label>

          <div v-if="curve.manualKB" class="rc-kb-manual">
            <div class="form-row"><label>k (наклон)</label><input v-model="curve.kManual" type="number" step="any" placeholder="19.88" /></div>
            <div class="form-row"><label>b (пересечение)</label><input v-model="curve.bManual" type="number" step="any" placeholder="-0.09898" /></div>
          </div>

          <template v-else>
            <div class="rc-points-table">
              <div class="rc-points-header">
                <span>Концентрация ({{ curve.unit === 'mkg_ml' ? 'мкг/мл' : 'мг/мл' }})</span>
                <span>OD (оптическая плотность)</span>
                <span></span>
              </div>
              <div v-for="(p, idx) in curve.points" :key="idx" class="rc-points-row">
                <input v-model="p.conc" type="number" step="any" placeholder="0.47" />
                <input v-model="p.od" type="number" step="any" placeholder="0.335" />
                <button v-if="curve.points.length > 2" class="icon-btn" @click="removePoint(curve, idx)">✕</button>
              </div>
            </div>
            <button class="btn btn-tiny" @click="addPoint(curve)">+ Точка калибровки</button>
          </template>

          <div class="rc-curve-result">
            <template v-if="curveStats(curve).k !== null">
              <span class="rc-formula">Y = {{ fmt(curveStats(curve).k, 3) }}·X {{ curveStats(curve).b >= 0 ? '+' : '−' }} {{ fmt(Math.abs(curveStats(curve).b), 4) }}</span>
              <span v-if="curveStats(curve).r2 !== null" class="muted">R² = {{ fmt(curveStats(curve).r2, 4) }}</span>
              <span class="muted">Обратная формула: концентрация = (OD − b) / k</span>
            </template>
            <template v-else>
              <span class="muted">Добавьте минимум 2 точки калибровки (концентрация + OD), чтобы рассчитать k и b.</span>
            </template>
          </div>

          <div v-if="calibrationChart(curve).pts.length" class="rc-chart-wrap">
            <svg :width="calibrationChart(curve).W" :height="calibrationChart(curve).H" class="rc-svg">
              <line :x1="0" :y1="calibrationChart(curve).H-28" :x2="calibrationChart(curve).W" :y2="calibrationChart(curve).H-28" class="rc-axis" />
              <line :x1="28" :y1="0" :x2="28" :y2="calibrationChart(curve).H" class="rc-axis" />
              <path v-if="calibrationChart(curve).line" :d="calibrationChart(curve).line" class="rc-line" />
              <circle v-for="(pt, i) in calibrationChart(curve).pts" :key="i" :cx="pt.cx" :cy="pt.cy" r="4" class="rc-point" />
            </svg>
            <div class="rc-chart-caption">X: {{ calibrationChart(curve).xLabel }} · Y: {{ calibrationChart(curve).yLabel }}</div>
          </div>
        </template>
      </div>
    </div>

    <!-- ═══ ШАГ 2 · ПОМОЩНИК РАЗВЕДЕНИЯ ═══ -->
    <div id="rc-step-dilution" class="rc-step rc-step-dilution">
      <div class="rc-step-header">
        <span class="rc-step-badge rc-step-badge-lg">2</span>
        <div>
          <div class="group-title">Калькулятор разведения</div>
          <div class="rc-step-sub">Необязательный шаг — используйте, если разбавляли пробу перед измерением OD</div>
        </div>
        <button class="btn btn-tiny rc-add-btn" @click="dilutionOpen = !dilutionOpen">
          {{ dilutionOpen ? 'Свернуть' : 'Развернуть' }}
        </button>
      </div>

      <div v-if="dilutionOpen" class="rc-card rc-card-dilution">
        <div class="rc-dilution-modes">
          <button class="btn btn-tiny" :class="{ active: dilutionHelper.mode === 'ratio' }" @click="dilutionHelper.mode = 'ratio'">По частям (X : Y)</button>
          <button class="btn btn-tiny" :class="{ active: dilutionHelper.mode === 'volume' }" @click="dilutionHelper.mode = 'volume'">По объёму (аликвота → итог)</button>
        </div>

        <div v-if="dilutionHelper.mode === 'ratio'" class="rc-dilution-body">
          <div class="rc-dilution-inputs">
            <div class="form-row"><label>Частей образца</label><input v-model="dilutionHelper.ratioSample" type="number" step="any" /></div>
            <span class="rc-colon">:</span>
            <div class="form-row"><label>Частей растворителя</label><input v-model="dilutionHelper.ratioDiluent" type="number" step="any" /></div>
          </div>
          <div class="rc-dilution-hint">
            ⚠️ Частая ошибка: запись «1:1» — это <strong>не</strong> разведение ×1. Смешали 1 часть образца + 1 часть растворителя →
            итоговый объём стал в 2 раза больше исходного, значит разведение ×2.
            Формула: (части образца + части растворителя) / части образца.
          </div>
        </div>
        <div v-else class="rc-dilution-body">
          <div class="rc-dilution-inputs">
            <div class="form-row"><label>Объём аликвоты, мкл</label><input v-model="dilutionHelper.aliquot" type="number" step="any" /></div>
            <span class="rc-colon">→</span>
            <div class="form-row"><label>Итоговый объём, мкл</label><input v-model="dilutionHelper.totalVolume" type="number" step="any" /></div>
          </div>
          <div class="rc-dilution-hint">
            Пример: взяли 20 мкл раствора и довели буфером до 1000 мкл → разведение = 1000 / 20 = <strong>×50</strong>.
            Формула: итоговый объём / объём взятой аликвоты.
          </div>
        </div>

        <div class="rc-dilution-result">
          Кратность разведения:
          <strong>{{ dilutionHelperResult !== null ? '×' + fmt(dilutionHelperResult, 2) : '—' }}</strong>
          <span class="muted"> — впишите это число в поле «Разведение (×)» нужной строки образца в шаге 3.</span>
        </div>
      </div>
    </div>

    <!-- ═══ ШАГ 3 · ОБРАЗЦЫ ═══ -->
    <div id="rc-step-samples" class="rc-step rc-step-samples">
      <div class="rc-step-header">
        <span class="rc-step-badge rc-step-badge-lg">3</span>
        <div>
          <div class="group-title">Образцы для сравнения релиза</div>
          <div class="rc-step-sub">Можно вести несколько образцов одновременно — каждый со своей калибровкой</div>
        </div>
        <button class="btn btn-tiny rc-add-btn" @click="addSample">+ Добавить образец</button>
      </div>

      <div v-for="(sw, sIdx) in samplesWithResults" :key="sw.sample.id" class="rc-card rc-card-sample" :style="{ borderLeft: '5px solid ' + palette[sIdx % palette.length] }">
        <div class="rc-card-top">
          <button class="rc-collapse-btn" @click="toggleSample(sw.sample.id)">
            {{ isSampleOpen(sw.sample.id) ? '▾' : '▸' }}
          </button>
          <span class="rc-sample-dot" :style="{ background: palette[sIdx % palette.length] }"></span>
          <input v-model="sw.sample.name" type="text" placeholder="Название образца, например: Ca-CO3 НЧ" class="rc-name-input" />
          <select v-model="sw.sample.curveId" class="rc-small-input">
            <option value="" disabled>Калибровка</option>
            <option v-for="c in curves" :key="c.id" :value="c.id">{{ c.name || 'Без названия' }}</option>
          </select>
          <button v-if="samples.length > 1" class="icon-btn" title="Удалить образец" @click="removeSample(sw.sample.id)">🗑️</button>
        </div>

        <!-- свёрнутый вид: только среда + итоговый % релиза -->
        <div v-if="!isSampleOpen(sw.sample.id)" class="rc-collapsed-summary">
          <span class="muted">Среда: {{ sw.curveName }}</span>
          <span v-if="lastRelease(sw.results) !== null" class="rc-formula">
            Итоговый релиз: {{ fmt(lastRelease(sw.results), 2) }} %
          </span>
          <span v-else class="muted">Нет данных релиза — раскройте карточку.</span>
        </div>

        <template v-else>
          <div class="form-grid-2">
            <div class="form-row">
              <label>Загруженная (запакованная) масса вещества, мг</label>
              <input v-model="sw.sample.totalLoadedMg" type="number" step="any" placeholder="Например: 24.2" />
            </div>
            <div class="form-row">
              <label>Объём среды релиза, мл</label>
              <input v-model="sw.sample.volumeMl" type="number" step="any" placeholder="Например: 10" />
            </div>
          </div>

          <div class="rc-rows-table">
            <div class="rc-rows-header">
              <span>Время, ч</span><span>OD1</span><span>OD2</span><span>OD3</span><span>Разведение (×)</span><span></span>
            </div>
            <div v-for="(row, rIdx) in sw.sample.rows" :key="rIdx" class="rc-rows-row">
              <input v-model="row.time" type="number" step="any" placeholder="24" />
              <input v-model="row.od1" type="number" step="any" placeholder="0.335" />
              <input v-model="row.od2" type="number" step="any" placeholder="0.336" />
              <input v-model="row.od3" type="number" step="any" placeholder="0.333" />
              <input v-model="row.dilution" type="number" step="any" placeholder="1" />
              <button v-if="sw.sample.rows.length > 1" class="icon-btn" @click="removeRow(sw.sample, rIdx)">✕</button>
            </div>
            <button class="btn btn-tiny" @click="addRow(sw.sample)">+ Точка времени</button>
          </div>

          <div class="results-table-wrap" style="margin-top: var(--space-3)">
            <table class="results-table">
              <thead>
                <tr>
                  <th>Время, ч</th><th>OD ср.</th>
                  <th>Концентрация в р-ре, мг/мл</th>
                  <th>Масса в растворе, мг</th>
                  <th>Процент в растворе %</th>
                  <th>Процент оставшийся %</th>
                  <th>Процент релиза, %</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(r, idx) in sw.results" :key="idx">
                  <td>{{ r.time }}</td>
                  <td>{{ fmt(r.odMean, 4) }}</td>
                  <td>{{ fmt(r.concMgMl, 4) }}</td>
                  <td>{{ fmt(r.massMg, 4) }}</td>
                  <td>{{ fmt(r.percentInSolution, 2) }}</td>
                  <td>{{ fmt(r.percentRemaining, 2) }}</td>
                  <td><strong>{{ fmt(r.percentRelease, 2) }}</strong></td>
                </tr>
              </tbody>
            </table>
          </div>

          <div v-if="releaseChart(sw.results, palette[sIdx % palette.length]).points.length" class="rc-chart-wrap">
            <svg :width="releaseChart(sw.results, palette[sIdx % palette.length]).W" :height="releaseChart(sw.results, palette[sIdx % palette.length]).H" class="rc-svg">
              <path :d="releaseChart(sw.results, palette[sIdx % palette.length]).path" fill="none" :stroke="palette[sIdx % palette.length]" stroke-width="2" />
              <circle v-for="(pt, i) in releaseChart(sw.results, palette[sIdx % palette.length]).points" :key="i" :cx="pt.cx" :cy="pt.cy" r="3" :fill="palette[sIdx % palette.length]" />
            </svg>
            <div class="rc-chart-caption">% релиза (накопительно) от времени, ч</div>
          </div>
        </template>
      </div>

      <!-- ═══ ОБЩИЙ СРАВНИТЕЛЬНЫЙ ГРАФИК ═══ -->
      <div v-if="combinedChart.series.length > 1" class="rc-card rc-card-combined">
        <div class="group-title">Сравнение образцов — накопительный релиз, %</div>
        <div class="rc-chart-wrap">
          <svg :width="combinedChart.W" :height="combinedChart.H" class="rc-svg">
            <line :x1="0" :y1="combinedChart.H-30" :x2="combinedChart.W" :y2="combinedChart.H-30" class="rc-axis" />
            <line :x1="34" :y1="0" :x2="34" :y2="combinedChart.H" class="rc-axis" />
            <path v-for="(s, i) in combinedChart.series" :key="i" :d="s.path" fill="none" :stroke="s.color" stroke-width="2.5" />
          </svg>
          <div class="rc-legend">
            <span v-for="(s, i) in combinedChart.series" :key="i" class="rc-legend-item">
              <span class="rc-legend-dot" :style="{ background: s.color }"></span>{{ s.name }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- ═══ ШАГ 4 · ЭКСПОРТ ═══ -->
    <div id="rc-step-export" class="rc-step rc-step-export">
      <div class="rc-step-header">
        <span class="rc-step-badge rc-step-badge-lg">4</span>
        <div>
          <div class="group-title">Экспорт результатов</div>
          <div class="rc-step-sub">Скачайте итоговую таблицу для отчёта или архива</div>
        </div>
      </div>
      <div class="rc-card rc-card-export">
        <div class="experiment-actions">
          <button class="btn btn-primary" :disabled="exporting" @click="exportExcel">
            {{ exporting ? 'Экспорт…' : '📊 Скачать Excel' }}
          </button>
          <button class="btn" @click="exportFullCsv">📄 Скачать CSV (все данные: калибровки + образцы)</button>
        </div>
        <div v-if="exportError" class="form-error">{{ exportError }}</div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.release-calc { display: grid; gap: var(--space-6); }

/* ─── шпаргалка / навигация ─── */
.rc-guide {
  background: color-mix(in srgb, var(--color-primary) 8%, var(--color-surface));
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  display: grid; gap: var(--space-3);
}
.rc-guide-title { font-weight: 700; font-size: var(--text-md); }
.rc-guide-steps { display: flex; gap: .6rem; flex-wrap: wrap; }
.rc-guide-step {
  display: flex; align-items: center; gap: .4rem;
  background: var(--color-surface); border: 1px solid var(--color-border);
  border-radius: 999px; padding: .4rem .9rem; cursor: pointer;
  font-size: var(--text-sm); color: var(--color-text);
}
.rc-guide-step:hover { border-color: var(--color-primary); }
.rc-guide-list { margin: 0; padding-left: 1.2rem; display: grid; gap: .3rem; font-size: var(--text-sm); color: var(--color-text-muted); }

.rc-step-badge {
  display: inline-flex; align-items: center; justify-content: center;
  width: 1.4rem; height: 1.4rem; border-radius: 999px;
  background: var(--color-primary); color: white; font-weight: 700; font-size: .75rem;
  flex-shrink: 0;
}
.rc-step-badge-lg { width: 2.2rem; height: 2.2rem; font-size: 1rem; }
.rc-step-icon { font-size: 1rem; }

/* ─── общая обёртка каждого шага, свой цвет фона ─── */
.rc-step {
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  display: grid; gap: var(--space-3);
  border: 1px solid var(--color-border);
}
.rc-step-calib { background: color-mix(in srgb, #0f7c82 6%, var(--color-surface)); }
.rc-step-dilution { background: color-mix(in srgb, #d97706 7%, var(--color-surface)); }
.rc-step-samples { background: color-mix(in srgb, #2563eb 5%, var(--color-surface)); }
.rc-step-export { background: color-mix(in srgb, #16a34a 6%, var(--color-surface)); }

.rc-step-header { display: flex; gap: .8rem; align-items: flex-start; flex-wrap: wrap; }
.rc-step-header > div:nth-child(2) { flex: 1 1 auto; }
.rc-step-sub { font-size: var(--text-sm); color: var(--color-text-muted); margin-top: .1rem; }
.rc-add-btn { margin-left: auto; }

.rc-card {
  background: var(--color-surface-2);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  display: grid; gap: var(--space-3);
}
.rc-card-calib { border-top: 3px solid #0f7c82; }
.rc-card-dilution { border-top: 3px solid #d97706; }
.rc-card-sample { border-top: 3px solid transparent; }
.rc-card-combined { border-top: 3px solid #2563eb; }
.rc-card-export { border-top: 3px solid #16a34a; }

.rc-card-top { display: flex; gap: .6rem; flex-wrap: wrap; align-items: center; }
.rc-collapse-btn {
  border: none; background: transparent; cursor: pointer;
  font-size: 1.1rem; line-height: 1; color: var(--color-text-muted);
  width: 1.4rem; flex-shrink: 0;
}
.rc-collapse-btn:hover { color: var(--color-primary); }
.rc-collapsed-summary { display: flex; gap: 1rem; flex-wrap: wrap; align-items: center; font-size: var(--text-sm); padding: .2rem 0; }
.rc-sample-dot { width: 10px; height: 10px; border-radius: 999px; flex-shrink: 0; }

.rc-name-input { flex: 1 1 220px; min-width: 160px; padding: .6rem .8rem; border-radius: var(--radius-md); border: 1px solid var(--color-border); background: var(--color-surface); color: var(--color-text); }
.rc-small-input { padding: .6rem .7rem; border-radius: var(--radius-md); border: 1px solid var(--color-border); background: var(--color-surface); color: var(--color-text); width: 110px; }
.rc-checkbox-row { display: flex; align-items: center; gap: .5rem; font-size: var(--text-sm); color: var(--color-text-muted); }
.rc-kb-manual { display: flex; gap: 1rem; flex-wrap: wrap; }
.rc-points-table { display: grid; gap: .4rem; }
.rc-points-header, .rc-points-row { display: grid; grid-template-columns: 1fr 1fr 2rem; gap: .5rem; align-items: center; }
.rc-points-header { font-size: var(--text-xs); color: var(--color-text-muted); text-transform: uppercase; }
.rc-points-row input { padding: .5rem .6rem; border-radius: var(--radius-sm); border: 1px solid var(--color-border); background: var(--color-surface); color: var(--color-text); }
.rc-curve-result { display: flex; gap: 1rem; flex-wrap: wrap; align-items: center; font-size: var(--text-sm); }
.rc-formula { font-weight: 700; color: var(--color-primary); }
.rc-chart-wrap { display: grid; gap: .4rem; justify-items: start; }
.rc-svg { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-md); }
.rc-axis { stroke: var(--color-border); stroke-width: 1; }
.rc-line { stroke: var(--color-primary); stroke-width: 2; fill: none; }
.rc-point { fill: var(--color-primary-2); }
.rc-chart-caption { font-size: var(--text-xs); color: var(--color-text-muted); }

.rc-dilution-modes { display: flex; gap: .5rem; flex-wrap: wrap; }
.rc-dilution-modes .btn.active { background: linear-gradient(135deg, var(--color-primary), var(--color-primary-2)); color: white; border-color: transparent; }
.rc-dilution-body { display: grid; gap: .6rem; margin-top: .5rem; }
.rc-dilution-inputs { display: flex; align-items: flex-end; gap: .6rem; flex-wrap: wrap; }
.rc-colon { font-size: 1.2rem; font-weight: 700; color: var(--color-text-muted); padding-bottom: .6rem; }
.rc-dilution-hint { font-size: var(--text-sm); color: var(--color-text-muted); background: var(--color-surface); border-left: 3px solid var(--color-warning); border-radius: 0 var(--radius-sm) var(--radius-sm) 0; padding: var(--space-3); }
.rc-dilution-result { font-size: var(--text-sm); background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: var(--space-3); }

.rc-rows-table { display: grid; gap: .4rem; }
.rc-rows-header, .rc-rows-row { display: grid; grid-template-columns: 5rem 5rem 5rem 5rem 6rem 2rem; gap: .4rem; align-items: center; }
.rc-rows-header { font-size: var(--text-xs); color: var(--color-text-muted); text-transform: uppercase; }
.rc-rows-row input { padding: .5rem .5rem; border-radius: var(--radius-sm); border: 1px solid var(--color-border); background: var(--color-surface); color: var(--color-text); width: 100%; }
.rc-legend { display: flex; gap: 1rem; flex-wrap: wrap; }
.rc-legend-item { display: inline-flex; align-items: center; gap: .4rem; font-size: var(--text-sm); }
.rc-legend-dot { width: 10px; height: 10px; border-radius: 999px; display: inline-block; }

@media (max-width: 700px) {
  .rc-rows-header, .rc-rows-row { grid-template-columns: repeat(5, 1fr) 1.5rem; font-size: .8rem; }
  .rc-guide-steps { gap: .4rem; }
}
</style>

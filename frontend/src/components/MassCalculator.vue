<template>
  <div class="mc-card">
    <div class="mc-title">🧮 Калькулятор растворов</div>
    <div class="mc-subtitle">Навеска реагента или разведение готового раствора до нужной концентрации.</div>

    <div class="mc-mode-tabs">
      <button type="button" class="mc-mode-btn" :class="{ active: mode === 'weigh' }" @click="mode = 'weigh'">⚖️ Навеска</button>
      <button type="button" class="mc-mode-btn" :class="{ active: mode === 'dilute' }" @click="mode = 'dilute'">💧 Разведение</button>
    </div>

    <!-- ═══ РЕЖИМ: НАВЕСКА (m = C × V × M) ═══ -->
    <template v-if="mode === 'weigh'">
      <div class="mc-formula-caption">Формула: m = C × V × M</div>

      <div class="mc-row">
        <label class="mc-label">Что нужно найти?</label>
        <select v-model="target" class="mc-select-full">
          <option value="mass">Массу (m) — навеска</option>
          <option value="conc">Концентрацию (C)</option>
          <option value="vol">Объём (V)</option>
          <option value="molar">Молярную массу (M)</option>
        </select>
      </div>

      <hr class="mc-divider" />

      <div class="mc-row" v-if="target !== 'mass'">
        <label class="mc-label">Масса навески (m)</label>
        <div class="mc-inline">
          <input v-model.number="mass" type="number" step="any" placeholder="напр. 30" class="mc-input" />
          <select v-model="massUnit" class="mc-unit">
            <option value="g">г</option>
            <option value="mg">мг</option>
            <option value="ug">мкг</option>
          </select>
        </div>
      </div>

      <div class="mc-row" v-if="target !== 'conc'">
        <label class="mc-label">Концентрация (C)</label>
        <div class="mc-inline">
          <input v-model.number="concentration" type="number" step="any" placeholder="напр. 10" class="mc-input" />
          <select v-model="concUnit" class="mc-unit">
            <option v-for="u in CONC_UNITS" :key="u.value" :value="u.value">{{ u.label }}</option>
          </select>
        </div>
        <div class="mc-hint-small">концентрация — количество вещества на 1 литр раствора</div>
      </div>

      <div class="mc-row" v-if="target !== 'vol'">
        <label class="mc-label">Объём (V)</label>
        <div class="mc-inline">
          <input v-model.number="volume" type="number" step="any" placeholder="напр. 100" class="mc-input" />
          <select v-model="volUnit" class="mc-unit">
            <option value="L">л</option>
            <option value="mL">мл</option>
            <option value="uL">мкл</option>
          </select>
        </div>
      </div>

      <div class="mc-row" v-if="target !== 'molar'">
        <label class="mc-label">Молярная масса (M)</label>
        <div class="mc-inline">
          <input v-model.number="molarMass" type="number" step="any" placeholder="г/моль" class="mc-input" />
          <span class="mc-static-unit">г/моль</span>
        </div>
      </div>

      <div class="mc-result" v-if="weighResultText">
        <div class="mc-result-label">{{ weighTargetLabel }}</div>
        <div class="mc-result-value">{{ weighResultText }}</div>
        <div class="mc-result-formula">{{ weighFormulaHint }}</div>
      </div>
      <div class="mc-warning" v-else-if="weighHasAllInputs === false">
        Заполните все известные поля, чтобы получить результат.
      </div>
    </template>

    <!-- ═══ РЕЖИМ: РАЗВЕДЕНИЕ (C1×V1 = C2×V2) ═══ -->
    <template v-else>
      <div class="mc-formula-caption">Формула: C₁ × V₁ = C₂ × V₂</div>

      <div class="mc-row">
        <label class="mc-label">Концентрация исходного раствора (C₁)</label>
        <div class="mc-inline">
          <input v-model.number="c1" type="number" step="any" placeholder="напр. 3" class="mc-input" />
          <select v-model="c1Unit" class="mc-unit">
            <option v-for="u in CONC_UNITS" :key="u.value" :value="u.value">{{ u.label }}</option>
          </select>
        </div>
      </div>

      <div class="mc-row">
        <label class="mc-label">Нужная конечная концентрация (C₂)</label>
        <div class="mc-inline">
          <input v-model.number="c2" type="number" step="any" placeholder="напр. 1" class="mc-input" />
          <select v-model="c2Unit" class="mc-unit">
            <option v-for="u in CONC_UNITS" :key="u.value" :value="u.value">{{ u.label }}</option>
          </select>
        </div>
      </div>

      <div class="mc-row">
        <label class="mc-label">Нужный конечный объём (V₂)</label>
        <div class="mc-inline">
          <input v-model.number="v2" type="number" step="any" placeholder="напр. 15" class="mc-input" />
          <select v-model="v2Unit" class="mc-unit">
            <option value="L">л</option>
            <option value="mL">мл</option>
            <option value="uL">мкл</option>
          </select>
        </div>
      </div>

      <div class="mc-result" v-if="diluteResult">
        <div class="mc-result-label">Взять исходного раствора</div>
        <div class="mc-result-value">{{ diluteResult.v1 }}</div>
        <div class="mc-result-sub">+ добавить растворителя: <strong>{{ diluteResult.diluent }}</strong></div>
        <div class="mc-result-formula">до общего объёма {{ v2 }} {{ v2UnitLabel }} при C₂ = {{ c2 }} {{ c2UnitLabel }}</div>
      </div>
      <div class="mc-warning" v-else-if="diluteError">{{ diluteError }}</div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const mode = ref('weigh')

// ── Общий список единиц концентрации (по определению — «на литр раствора») ──
const CONC_UNITS = [
  { value: 'mol',  label: 'моль (M)',    scale: 1 },
  { value: 'mmol', label: 'ммоль (мМ)',  scale: 1e-3 },
  { value: 'umol', label: 'мкмоль (мкМ)', scale: 1e-6 },
  { value: 'nmol', label: 'нмоль (нМ)',  scale: 1e-9 },
  { value: 'pmol', label: 'пмоль (пМ)',  scale: 1e-12 },
  { value: 'fmol', label: 'фмоль (фМ)',  scale: 1e-15 },
]
const concScale = Object.fromEntries(CONC_UNITS.map(u => [u.value, u.scale]))
const concLabel = Object.fromEntries(CONC_UNITS.map(u => [u.value, u.label]))

const volToLiters = { L: 1, mL: 1e-3, uL: 1e-6 }

function formatConc(molPerL) {
  if (molPerL < 1e-12) return `${(molPerL * 1e15).toFixed(2)} фМ`
  if (molPerL < 1e-9) return `${(molPerL * 1e12).toFixed(2)} пМ`
  if (molPerL < 1e-6) return `${(molPerL * 1e9).toFixed(2)} нМ`
  if (molPerL < 1e-3) return `${(molPerL * 1e6).toFixed(3)} мкМ`
  if (molPerL < 1) return `${(molPerL * 1e3).toFixed(3)} мМ`
  return `${molPerL.toFixed(4)} М`
}

function formatVol(liters) {
  if (liters < 1e-3) return `${(liters * 1e6).toFixed(2)} мкл`
  if (liters < 1) return `${(liters * 1e3).toFixed(3)} мл`
  return `${liters.toFixed(4)} л`
}

function formatMass(g) {
  if (g < 0.000001) return `${(g * 1e9).toFixed(2)} нг`
  if (g < 0.001) return `${(g * 1e6).toFixed(2)} мкг`
  if (g < 1) return `${(g * 1000).toFixed(3)} мг`
  return `${g.toFixed(4)} г`
}

// ══════════════════ РЕЖИМ: НАВЕСКА ══════════════════
const target = ref('conc')

const mass = ref(null)
const massUnit = ref('mg')
const concentration = ref(null)
const concUnit = ref('mmol')
const volume = ref(null)
const volUnit = ref('mL')
const molarMass = ref(null)

const massToGrams = { g: 1, mg: 1e-3, ug: 1e-6 }

const mGrams = computed(() => (mass.value || 0) * massToGrams[massUnit.value])
const cMolPerL = computed(() => (concentration.value || 0) * concScale[concUnit.value])
const vLiters = computed(() => (volume.value || 0) * volToLiters[volUnit.value])
const mMolar = computed(() => molarMass.value || 0)

const weighTargetLabel = computed(() => ({
  mass: 'Нужно взвесить',
  conc: 'Получится концентрация',
  vol: 'Нужный объём',
  molar: 'Молярная масса вещества',
}[target.value]))

const weighFormulaHint = computed(() => ({
  mass: 'm = C × V × M',
  conc: 'C = m / (V × M)',
  vol: 'V = m / (C × M)',
  molar: 'M = m / (C × V)',
}[target.value]))

const weighHasAllInputs = computed(() => {
  if (target.value === 'mass') return !!concentration.value && !!volume.value && !!molarMass.value
  if (target.value === 'conc') return !!mass.value && !!volume.value && !!molarMass.value
  if (target.value === 'vol') return !!mass.value && !!concentration.value && !!molarMass.value
  if (target.value === 'molar') return !!mass.value && !!concentration.value && !!volume.value
  return false
})

const weighResultText = computed(() => {
  if (!weighHasAllInputs.value) return ''
  if (target.value === 'mass') return formatMass(cMolPerL.value * vLiters.value * mMolar.value)
  if (target.value === 'conc') return formatConc(mGrams.value / (vLiters.value * mMolar.value))
  if (target.value === 'vol') return formatVol(mGrams.value / (cMolPerL.value * mMolar.value))
  if (target.value === 'molar') return `${(mGrams.value / (cMolPerL.value * vLiters.value)).toFixed(3)} г/моль`
  return ''
})

// ══════════════════ РЕЖИМ: РАЗВЕДЕНИЕ ══════════════════
const c1 = ref(null)
const c1Unit = ref('mol')
const c2 = ref(null)
const c2Unit = ref('mol')
const v2 = ref(null)
const v2Unit = ref('mL')

const v2UnitLabel = computed(() => ({ L: 'л', mL: 'мл', uL: 'мкл' }[v2Unit.value]))
const c2UnitLabel = computed(() => concLabel[c2Unit.value])

const diluteError = computed(() => {
  if (!c1.value || !c2.value || !v2.value) return 'Заполните C₁, C₂ и V₂, чтобы получить результат.'
  const c1MolL = c1.value * concScale[c1Unit.value]
  const c2MolL = c2.value * concScale[c2Unit.value]
  if (c1MolL <= c2MolL) return 'Исходная концентрация (C₁) должна быть больше желаемой (C₂) — иначе разведением такую концентрацию не получить.'
  return ''
})

const diluteResult = computed(() => {
  if (diluteError.value) return null
  const c1MolL = c1.value * concScale[c1Unit.value]
  const c2MolL = c2.value * concScale[c2Unit.value]
  const v2L = v2.value * volToLiters[v2Unit.value]
  const v1L = (c2MolL * v2L) / c1MolL
  const diluentL = v2L - v1L
  return {
    v1: formatVol(v1L),
    diluent: formatVol(diluentL),
  }
})
</script>

<style scoped>
.mc-card {
  width: 100%;
  max-width: 480px;
  color: inherit;
  background: transparent;
  box-sizing: border-box;
}

.mc-title {
  font-size: clamp(0.95rem, 2.5vw, 1.1rem);
  font-weight: 600;
  margin-bottom: 4px;
}

.mc-subtitle {
  font-size: 0.82rem;
  opacity: 0.6;
  margin-bottom: 14px;
  line-height: 1.4;
}

.mc-mode-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}

.mc-mode-btn {
  flex: 1 1 auto;
  padding: 9px 10px;
  border-radius: 8px;
  border: 1px solid rgba(128, 128, 128, 0.35);
  background: transparent;
  color: inherit;
  font-size: 0.88rem;
  font-weight: 600;
  cursor: pointer;
  opacity: 0.6;
  transition: opacity 0.15s, background 0.15s;
}

.mc-mode-btn.active {
  opacity: 1;
  background: rgba(80, 160, 220, 0.15);
  border-color: rgba(80, 160, 220, 0.5);
}

.mc-formula-caption {
  font-size: 0.78rem;
  opacity: 0.5;
  font-style: italic;
  margin-bottom: 14px;
}

.mc-divider {
  border: none;
  border-top: 1px solid currentColor;
  opacity: 0.12;
  margin: 14px 0;
}

.mc-row {
  margin-bottom: 14px;
}

.mc-select-full {
  width: 100% !important;
  box-sizing: border-box;
  padding: 9px 10px;
  border-radius: 6px;
  border: 1px solid rgba(128, 128, 128, 0.35);
  background: transparent;
  color: inherit;
  font-size: 0.95rem;
}

.mc-label {
  display: block;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  opacity: 0.55;
  margin-bottom: 6px;
}

.mc-hint-small {
  font-size: 0.72rem;
  opacity: 0.45;
  margin-top: 4px;
}

.mc-inline {
  display: flex !important;
  flex-direction: row !important;
  flex-wrap: nowrap !important;
  align-items: center;
  gap: 8px;
  width: 100%;
}

.mc-input {
  flex: 1 1 auto !important;
  width: auto !important;
  min-width: 0;
  box-sizing: border-box;
  padding: 9px 10px;
  border-radius: 6px;
  border: 1px solid rgba(128, 128, 128, 0.35);
  background: transparent;
  color: inherit;
  font-size: 0.95rem;
}

.mc-input::placeholder {
  opacity: 0.45;
}

.mc-unit {
  flex: 0 0 auto !important;
  width: auto !important;
  min-width: 0;
  max-width: 46%;
  box-sizing: border-box;
  padding: 9px 6px;
  border-radius: 6px;
  border: 1px solid rgba(128, 128, 128, 0.35);
  background: transparent;
  color: inherit;
  font-size: 0.85rem;
}

.mc-select-full option,
.mc-unit option {
  color: #1a1a1a;
  background-color: #ffffff;
}

.mc-static-unit {
  flex: 0 0 auto;
  opacity: 0.6;
  font-size: 0.9rem;
  white-space: nowrap;
}

.mc-result {
  margin-top: 8px;
  padding: 16px;
  border-radius: 10px;
  border: 1px solid rgba(80, 200, 120, 0.4);
  background: rgba(80, 200, 120, 0.1);
  text-align: center;
}

.mc-result-label {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  opacity: 0.65;
  margin-bottom: 6px;
}

.mc-result-value {
  font-size: clamp(1.6rem, 7vw, 2.4rem);
  font-weight: 700;
  line-height: 1.15;
  word-break: break-word;
}

.mc-result-sub {
  font-size: 0.9rem;
  margin-top: 8px;
  opacity: 0.85;
}

.mc-result-formula {
  font-size: 0.78rem;
  opacity: 0.55;
  margin-top: 8px;
}

.mc-warning {
  margin-top: 8px;
  padding: 12px 14px;
  border-radius: 8px;
  border: 1px solid rgba(230, 160, 40, 0.4);
  background: rgba(230, 160, 40, 0.08);
  font-size: 0.88rem;
  opacity: 0.85;
}

@media (min-width: 768px) {
  .mc-card { max-width: 560px; }
  .mc-title { font-size: 1.2rem; }
  .mc-input, .mc-select-full { font-size: 1rem; padding: 10px 12px; }
  .mc-unit { font-size: 0.92rem; max-width: 40%; padding: 10px 10px; }
  .mc-result { padding: 22px; }
  .mc-result-value { font-size: 2.6rem; }
}

@media (max-width: 360px) {
  .mc-unit { font-size: 0.78rem; padding: 8px 4px; max-width: 50%; }
  .mc-input { padding: 8px 8px; font-size: 0.9rem; }
}
</style>

<template>
  <div class="mc-card">
    <div class="mc-title">🧮 Расчёт по формуле m = C × V × M</div>
    <div class="mc-subtitle">Если забыли одну величину — выберите её ниже, а остальные три введите.</div>

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
          <optgroup label="на литр">
            <option value="M">моль/л</option>
            <option value="mM">ммоль/л</option>
            <option value="uM">мкмоль/л</option>
          </optgroup>
          <optgroup label="на мл">
            <option value="M_mL">моль/мл</option>
            <option value="mM_mL">ммоль/мл</option>
            <option value="uM_mL">мкмоль/мл</option>
          </optgroup>
        </select>
      </div>
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

    <div class="mc-result" v-if="resultText">
      <div class="mc-result-label">{{ targetLabel }}</div>
      <div class="mc-result-value">{{ resultText }}</div>
      <div class="mc-result-formula">{{ formulaHint }}</div>
    </div>

    <div class="mc-warning" v-else-if="hasAllInputs === false">
      Заполните все известные поля, чтобы получить результат.
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const target = ref('conc')

const mass = ref(null)
const massUnit = ref('mg')
const concentration = ref(null)
const concUnit = ref('mM')
const volume = ref(null)
const volUnit = ref('mL')
const molarMass = ref(null)

const massToGrams = { g: 1, mg: 1e-3, ug: 1e-6 }
const concToMolPerL = {
  M: 1,
  mM: 1e-3,
  uM: 1e-6,
  M_mL: 1000,
  mM_mL: 1,
  uM_mL: 1e-3,
}
const volToLiters = { L: 1, mL: 1e-3, uL: 1e-6 }

const mGrams = computed(() => (mass.value || 0) * massToGrams[massUnit.value])
const cMolPerL = computed(() => (concentration.value || 0) * concToMolPerL[concUnit.value])
const vLiters = computed(() => (volume.value || 0) * volToLiters[volUnit.value])
const mMolar = computed(() => molarMass.value || 0)

const targetLabel = computed(() => ({
  mass: 'Результат — масса (m)',
  conc: 'Результат — концентрация (C)',
  vol: 'Результат — объём (V)',
  molar: 'Результат — молярная масса (M)',
}[target.value]))

const formulaHint = computed(() => ({
  mass: 'm = C × V × M',
  conc: 'C = m / (V × M)',
  vol: 'V = m / (C × M)',
  molar: 'M = m / (C × V)',
}[target.value]))

const hasAllInputs = computed(() => {
  if (target.value === 'mass') return !!concentration.value && !!volume.value && !!molarMass.value
  if (target.value === 'conc') return !!mass.value && !!volume.value && !!molarMass.value
  if (target.value === 'vol') return !!mass.value && !!concentration.value && !!molarMass.value
  if (target.value === 'molar') return !!mass.value && !!concentration.value && !!volume.value
  return false
})

function formatMass(g) {
  if (g < 0.000001) return `${(g * 1e9).toFixed(2)} нг`
  if (g < 0.001) return `${(g * 1e6).toFixed(2)} мкг`
  if (g < 1) return `${(g * 1000).toFixed(3)} мг`
  return `${g.toFixed(4)} г`
}

function formatConc(molPerL) {
  if (molPerL < 1e-6) return `${(molPerL * 1e9).toFixed(3)} нМ`
  if (molPerL < 1e-3) return `${(molPerL * 1e6).toFixed(3)} мкМ`
  if (molPerL < 1) return `${(molPerL * 1e3).toFixed(3)} мМ`
  return `${molPerL.toFixed(4)} М (моль/л)`
}

function formatVol(liters) {
  if (liters < 1e-3) return `${(liters * 1e6).toFixed(2)} мкл`
  if (liters < 1) return `${(liters * 1e3).toFixed(3)} мл`
  return `${liters.toFixed(4)} л`
}

const resultText = computed(() => {
  if (!hasAllInputs.value) return ''

  if (target.value === 'mass') {
    const g = cMolPerL.value * vLiters.value * mMolar.value
    return formatMass(g)
  }
  if (target.value === 'conc') {
    const molPerL = mGrams.value / (vLiters.value * mMolar.value)
    return formatConc(molPerL)
  }
  if (target.value === 'vol') {
    const liters = mGrams.value / (cMolPerL.value * mMolar.value)
    return formatVol(liters)
  }
  if (target.value === 'molar') {
    const gPerMol = mGrams.value / (cMolPerL.value * vLiters.value)
    return `${gPerMol.toFixed(3)} г/моль`
  }
  return ''
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
  margin-bottom: 16px;
  line-height: 1.4;
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

/* ФИКС контраста выпадающего списка: браузер рисует popup select'а
   поверх страницы своими средствами и почти не наследует тему сайта.
   Поэтому явно задаём цвет текста и фон именно для option/optgroup —
   так пункты списка всегда читаемы, независимо от темы приложения. */
.mc-select-full option,
.mc-unit option {
  color: #1a1a1a;
  background-color: #ffffff;
}

.mc-select-full optgroup,
.mc-unit optgroup {
  color: #555555;
  background-color: #f3f3f3;
  font-weight: 600;
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
  .mc-card {
    max-width: 560px;
  }
  .mc-title {
    font-size: 1.2rem;
  }
  .mc-input,
  .mc-select-full {
    font-size: 1rem;
    padding: 10px 12px;
  }
  .mc-unit {
    font-size: 0.92rem;
    max-width: 40%;
    padding: 10px 10px;
  }
  .mc-result {
    padding: 22px;
  }
  .mc-result-value {
    font-size: 2.6rem;
  }
}

@media (max-width: 360px) {
  .mc-unit {
    font-size: 0.78rem;
    padding: 8px 4px;
    max-width: 50%;
  }
  .mc-input {
    padding: 8px 8px;
    font-size: 0.9rem;
  }
}
</style>

<template>
  <div class="mass-calc-block">
    <div class="group-title">Расчёт по формуле m = C × V × M</div>

    <div class="form-row">
      <label>Что нужно найти?</label>
      <select v-model="target">
        <option value="mass">Массу (m) — навеска</option>
        <option value="conc">Концентрацию (C) — забыл(а) концентрацию</option>
        <option value="vol">Объём (V)</option>
        <option value="molar">Молярную массу (M)</option>
      </select>
    </div>

    <!-- Масса (m) -->
    <div class="form-row" v-if="target !== 'mass'">
      <label>Масса навески (m)</label>
      <div class="mass-calc-inline">
        <input v-model.number="mass" type="number" step="any" placeholder="напр. 30" />
        <select v-model="massUnit">
          <option value="g">г</option>
          <option value="mg">мг</option>
          <option value="ug">мкг</option>
        </select>
      </div>
    </div>

    <!-- Концентрация (C) -->
    <div class="form-row" v-if="target !== 'conc'">
      <label>Концентрация (C)</label>
      <div class="mass-calc-inline">
        <input v-model.number="concentration" type="number" step="any" placeholder="напр. 10" />
        <select v-model="concUnit">
          <option value="M">моль/л (M)</option>
          <option value="mM">ммоль/л (мМ)</option>
          <option value="uM">мкмоль/л (мкМ)</option>
        </select>
      </div>
    </div>

    <!-- Объём (V) -->
    <div class="form-row" v-if="target !== 'vol'">
      <label>Объём (V)</label>
      <div class="mass-calc-inline">
        <input v-model.number="volume" type="number" step="any" placeholder="напр. 100" />
        <select v-model="volUnit">
          <option value="L">л</option>
          <option value="mL">мл</option>
          <option value="uL">мкл</option>
        </select>
      </div>
    </div>

    <!-- Молярная масса (M) -->
    <div class="form-row" v-if="target !== 'molar'">
      <label>Молярная масса (M)</label>
      <div class="mass-calc-inline">
        <input v-model.number="molarMass" type="number" step="any" placeholder="г/моль" />
        <span class="muted">г/моль</span>
      </div>
    </div>

    <div class="formula-block" v-if="resultText">
      <div><strong>Результат ({{ targetLabel }}):</strong> {{ resultText }}</div>
      <div class="muted">Формула: {{ formulaHint }}</div>
    </div>

    <div class="form-error" v-else-if="hasAllInputs === false">
      Заполните все известные поля, чтобы получить результат.
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const target = ref('conc') // по умолчанию — решаем задачу "забыл концентрацию"

const mass = ref(null)
const massUnit = ref('mg')
const concentration = ref(null)
const concUnit = ref('mM')
const volume = ref(null)
const volUnit = ref('mL')
const molarMass = ref(null)

const massToGrams = { g: 1, mg: 1e-3, ug: 1e-6 }
const concToMolPerL = { M: 1, mM: 1e-3, uM: 1e-6 }
const volToLiters = { L: 1, mL: 1e-3, uL: 1e-6 }

const mGrams = computed(() => (mass.value || 0) * massToGrams[massUnit.value])
const cMolPerL = computed(() => (concentration.value || 0) * concToMolPerL[concUnit.value])
const vLiters = computed(() => (volume.value || 0) * volToLiters[volUnit.value])
const mMolar = computed(() => molarMass.value || 0)

const targetLabel = computed(() => ({
  mass: 'масса, m',
  conc: 'концентрация, C',
  vol: 'объём, V',
  molar: 'молярная масса, M',
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
/*
  Никаких собственных цветов/фонов — компонент наследует тему
  через классы приложения: group-title, form-row, muted,
  formula-block, form-error. Здесь только layout-правки.
*/
.mass-calc-block {
  margin-top: 1rem;
}
.mass-calc-inline {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.mass-calc-inline input {
  width: 120px;
}
</style>

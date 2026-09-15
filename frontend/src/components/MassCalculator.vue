<template>
  <div class="mass-calculator">
    <h3>Расчёт по формуле m = C × V × M</h3>

    <div class="calc-row">
      <label>Что нужно найти?</label>
      <select v-model="target">
        <option value="mass">Массу (m) — навеска</option>
        <option value="conc">Концентрацию (C) — забыл(а) концентрацию</option>
        <option value="vol">Объём (V)</option>
        <option value="molar">Молярную массу (M)</option>
      </select>
    </div>

    <hr />

    <!-- Масса (m): всегда либо вход, либо результат -->
    <div class="calc-row" v-if="target !== 'mass'">
      <label>Масса навески (m)</label>
      <input v-model.number="mass" type="number" step="any" placeholder="напр. 30" />
      <select v-model="massUnit">
        <option value="g">г</option>
        <option value="mg">мг</option>
        <option value="ug">мкг</option>
      </select>
    </div>

    <!-- Концентрация (C) -->
    <div class="calc-row" v-if="target !== 'conc'">
      <label>Концентрация (C)</label>
      <input v-model.number="concentration" type="number" step="any" placeholder="напр. 10" />
      <select v-model="concUnit">
        <option value="M">моль/л (M)</option>
        <option value="mM">ммоль/л (мМ)</option>
        <option value="uM">мкмоль/л (мкМ)</option>
      </select>
    </div>

    <!-- Объём (V) -->
    <div class="calc-row" v-if="target !== 'vol'">
      <label>Объём (V)</label>
      <input v-model.number="volume" type="number" step="any" placeholder="напр. 100" />
      <select v-model="volUnit">
        <option value="L">л</option>
        <option value="mL">мл</option>
        <option value="uL">мкл</option>
      </select>
    </div>

    <!-- Молярная масса (M) -->
    <div class="calc-row" v-if="target !== 'molar'">
      <label>Молярная масса (M)</label>
      <input v-model.number="molarMass" type="number" step="any" placeholder="г/моль" />
      <span class="unit-static">г/моль</span>
    </div>

    <div class="calc-result" v-if="resultText">
      <p><strong>Результат ({{ targetLabel }}):</strong> {{ resultText }}</p>
      <p class="calc-hint">
        Формула: {{ formulaHint }}
      </p>
    </div>

    <div class="calc-warning" v-else-if="hasAllInputs === false">
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

// Проверка, что все нужные поля заполнены (кроме искомого)
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
    // C = m / (V * M), результат в моль/л
    const molPerL = mGrams.value / (vLiters.value * mMolar.value)
    return formatConc(molPerL)
  }
  if (target.value === 'vol') {
    // V = m / (C * M), результат в литрах
    const liters = mGrams.value / (cMolPerL.value * mMolar.value)
    return formatVol(liters)
  }
  if (target.value === 'molar') {
    // M = m / (C * V), результат в г/моль
    const gPerMol = mGrams.value / (cMolPerL.value * vLiters.value)
    return `${gPerMol.toFixed(3)} г/моль`
  }
  return ''
})
</script>

<style scoped>
.mass-calculator {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 16px;
  margin-top: 12px;
  background: #fff;
}
.calc-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}
.calc-row label {
  min-width: 170px;
}
.calc-row input {
  width: 110px;
  padding: 4px 6px;
}
.calc-row select {
  padding: 4px 6px;
}
.unit-static {
  color: #666;
}
.calc-result {
  margin-top: 12px;
  padding: 10px 12px;
  background: #f0f7f0;
  border-radius: 6px;
}
.calc-warning {
  margin-top: 12px;
  padding: 10px 12px;
  background: #fff6e5;
  border-radius: 6px;
  color: #8a6d3b;
}
.calc-hint {
  font-size: 0.85em;
  color: #777;
  margin-top: 4px;
}
</style>

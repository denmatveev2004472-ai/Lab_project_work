<script setup>
defineProps({
  t: { type: Function, required: true },
  loading: { type: Boolean, default: false },
  error: { type: String, default: '' },
  hasFile: { type: Boolean, default: false },
  result: { type: Object, default: null }
})

const emit = defineEmits(['file-change', 'process', 'download'])
</script>

<template>
  <div class="experiment-card">
    <div class="section-title">{{ t('alamarBlue') }}</div>
    <div class="experiment-hint">
      Загрузите Excel-файл с сырыми данными планшета (570 нм и 600 нм). Система рассчитает жизнеспособность клеток.
    </div>

    <div class="form-row" style="margin-top: 1rem">
      <input type="file" accept=".xlsx,.xls" @change="emit('file-change', $event)" />
    </div>

    <div class="experiment-actions">
      <button class="btn btn-primary" :disabled="loading || !hasFile" @click="emit('process')">
        {{ loading ? t('processing') : t('process') }}
      </button>
      <button v-if="result" class="btn" @click="emit('download')">📊 {{ t('downloadExcel') }}</button>
    </div>

    <div v-if="error" class="form-error">{{ error }}</div>

    <div v-if="result && result.samples" class="experiment-results">
      <div class="group-title">{{ t('results') }}</div>
      <div class="results-table-wrap">
        <table class="results-table">
          <thead>
            <tr>
              <th>{{ t('sample') }}</th>
              <th>{{ t('mean') }} (+ctrl)</th>
              <th>{{ t('std') }}</th>
              <th>{{ t('mean') }} (-ctrl)</th>
              <th>{{ t('std') }}</th>
              <th>n</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="sample in result.samples" :key="sample.name">
              <td><strong>{{ sample.name }}</strong></td>
              <td>{{ sample.mean_positive_control }}</td>
              <td>{{ sample.std_positive_control }}</td>
              <td>{{ sample.mean_negative_control ?? '—' }}</td>
              <td>{{ sample.std_negative_control ?? '—' }}</td>
              <td>{{ sample.n }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="chart-block">
        <div class="chart-title">{{ t('viability') }}</div>
        <div class="chart-bars">
          <div v-for="sample in result.samples" :key="sample.name" class="chart-bar-row">
            <span class="chart-label">{{ sample.name }}</span>
            <div class="chart-bar-track">
              <div class="chart-bar-fill" :style="{ width: Math.min(sample.mean_positive_control, 100) + '%' }"></div>
            </div>
            <span class="chart-value">{{ sample.mean_positive_control }}%</span>
          </div>
        </div>
      </div>

      <div class="formula-block">
        <div class="muted">{{ result.formula_corrected }}</div>
        <div class="muted">{{ result.formula_positive }}</div>
        <div class="muted">{{ result.formula_negative }}</div>
      </div>
    </div>
  </div>
</template>

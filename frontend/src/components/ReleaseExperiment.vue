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
    <div class="section-title">{{ t('release') }}</div>
    <div class="experiment-hint">
      Загрузите Excel-файл с данными загрузки и релиза. Система рассчитает эффективность загрузки и профиль высвобождения.
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

    <div v-if="result && result.loading" class="experiment-results">
      <div class="group-title">{{ t('loadingBlock') }}</div>
      <div class="results-grid">
        <div class="result-kv">
          <span class="result-k">{{ t('encapsulationEff') }}</span>
          <span class="result-v">{{ result.loading.percent_loaded ?? '—' }} %</span>
        </div>
        <div class="result-kv">
          <span class="result-k">Запакованная масса</span>
          <span class="result-v">{{ result.loading.encapsulated_mass_mg ?? '—' }} мг</span>
        </div>
      </div>

      <div v-for="(profile, profileIndex) in result.release_profiles" :key="profileIndex" class="release-profile-block">
        <div class="group-title">{{ t('releaseProfile') }} — {{ profile.solvent || '—' }}</div>
        <div class="results-table-wrap">
          <table class="results-table">
            <thead>
              <tr>
                <th>{{ t('timeH') }}</th>
                <th>OD mean</th>
                <th>Конц. мг/мл</th>
                <th>Масса мг</th>
                <th>% в растворе</th>
                <th>% осталось</th>
                <th>% релиза</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in profile.rows" :key="row.time">
                <td>{{ row.time }}</td>
                <td>{{ row.od_mean ?? '—' }}</td>
                <td>{{ row.concentration_mg_ml ?? '—' }}</td>
                <td>{{ row.mass_mg ?? '—' }}</td>
                <td>{{ row.percent_in_solution ?? '—' }}</td>
                <td>{{ row.percent_remaining ?? '—' }}</td>
                <td><strong>{{ row.percent_release ?? '—' }}</strong></td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="chart-block">
          <div class="chart-title">{{ t('cumulativeRelease') }}</div>
          <div class="chart-bars">
            <div v-for="row in profile.rows" :key="row.time" class="chart-bar-row">
              <span class="chart-label">{{ row.time }}</span>
              <div class="chart-bar-track">
                <div class="chart-bar-fill release-fill" :style="{ width: Math.min(row.percent_release || 0, 100) + '%' }"></div>
              </div>
              <span class="chart-value">{{ row.percent_release ?? '—' }}%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  t: { type: Function, required: true },
  language: { type: String, default: 'ru' }
})
</script>

<template>
  <div class="experiment-card muted">
    {{ t('dls') }} — {{ language === 'ru' ? 'в разработке' : 'coming soon' }}
  </div>
</template>

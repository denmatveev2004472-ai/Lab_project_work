import { createApp } from 'vue'
import App from './App.vue'
import ScheduleOnly from './ScheduleOnly.vue'

const host = window.location.hostname
const isLocalHost = host === 'localhost' || host === '127.0.0.1' || host === '::1' ||
  /^10\./.test(host) || /^192\.168\./.test(host) || /^172\.(1[6-9]|2\d|3[01])\./.test(host)
const forceSchedule = new URLSearchParams(window.location.search).get('view') === 'schedule'

createApp(isLocalHost && !forceSchedule ? App : ScheduleOnly).mount('#app')

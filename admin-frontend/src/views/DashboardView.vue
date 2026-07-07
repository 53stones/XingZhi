<template>
  <div class="grid">
    <div v-for="card in cards" :key="card.label" class="metric-card">
      <span>{{ card.label }}</span>
      <strong>{{ card.value }}</strong>
    </div>
  </div>
  <section class="panel">
    <div class="panel-head">
      <div>
        <h2>求助状态分布</h2>
        <p>用于快速判断当前平台压力与响应质量</p>
      </div>
      <button @click="load">刷新</button>
    </div>
    <div class="status-grid">
      <div><span>待响应</span><strong>{{ overview.pendingHelpCount || 0 }}</strong></div>
      <div><span>已响应</span><strong>{{ overview.respondedHelpCount || 0 }}</strong></div>
      <div><span>进行中</span><strong>{{ overview.processingHelpCount || 0 }}</strong></div>
      <div><span>已完成</span><strong>{{ overview.finishedHelpCount || 0 }}</strong></div>
      <div><span>高危</span><strong>{{ overview.dangerHelpCount || 0 }}</strong></div>
      <div><span>响应率</span><strong>{{ rate }}</strong></div>
    </div>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { api } from '../api/admin'

const overview = ref({})
const cards = computed(() => [
  { label: '用户总数', value: overview.value.userCount || 0 },
  { label: '管理员', value: overview.value.adminCount || 0 },
  { label: '求助事件', value: overview.value.helpEventCount || 0 },
  { label: '今日求助', value: overview.value.todayHelpCount || 0 },
  { label: '响应记录', value: overview.value.responseRecordCount || 0 },
  { label: '通知记录', value: overview.value.notifyRecordCount || 0 }
])
const rate = computed(() => `${((overview.value.responseRate || 0) * 100).toFixed(1)}%`)

async function load() {
  overview.value = await api.overview()
}

onMounted(load)
</script>

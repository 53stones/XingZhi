<template>
  <DataTable
    title="通知记录"
    subtitle="跟踪附近求助通知触达、振动提醒和接收状态"
    :columns="columns"
    :rows="rows"
    :total="total"
    :page="query.page"
    :size="query.size"
    :loading="loading"
    @page="setPage"
  >
    <template #actions>
      <div class="filters">
        <input v-model.trim="query.keyword" placeholder="接收人/求助类型" @keyup.enter="load" />
        <button @click="load">查询</button>
      </div>
    </template>
    <template #cell-notifyStatusName="{ row }">
      <span class="tag ok">{{ row.notifyStatusName || '-' }}</span>
    </template>
    <template #cell-needVibrationName="{ row }">
      <span :class="['tag', row.needVibration === 1 ? 'warn' : 'muted']">{{ row.needVibrationName || '-' }}</span>
    </template>
  </DataTable>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { api } from '../api/admin'
import DataTable from '../components/DataTable.vue'

const columns = [
  { key: 'id', label: 'ID' },
  { key: 'helpId', label: '求助ID' },
  { key: 'helpType', label: '求助类型' },
  { key: 'emergencyLevelName', label: '等级' },
  { key: 'receiverName', label: '接收人' },
  { key: 'receiverPhone', label: '电话' },
  { key: 'needVibrationName', label: '振动' },
  { key: 'notifyStatusName', label: '状态' },
  { key: 'createTime', label: '通知时间' }
]
const query = reactive({ page: 1, size: 10, keyword: '' })
const rows = ref([])
const total = ref(0)
const loading = ref(false)
async function load() {
  loading.value = true
  try {
    const data = await api.notifyRecords(query)
    rows.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}
function setPage(page) { query.page = page; load() }
onMounted(load)
</script>

<template>
  <DataTable
    title="响应记录"
    subtitle="查看互助响应人、距离与处理状态"
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
        <input v-model.trim="query.keyword" placeholder="响应人/求助类型" @keyup.enter="load" />
        <button @click="load">查询</button>
      </div>
    </template>
    <template #cell-responseStatusName="{ row }">
      <span class="tag ok">{{ row.responseStatusName || '-' }}</span>
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
  { key: 'responderName', label: '响应人' },
  { key: 'responderPhone', label: '电话' },
  { key: 'distance', label: '距离' },
  { key: 'responseStatusName', label: '状态' },
  { key: 'responseTime', label: '响应时间' }
]
const query = reactive({ page: 1, size: 10, keyword: '' })
const rows = ref([])
const total = ref(0)
const loading = ref(false)
async function load() {
  loading.value = true
  try {
    const data = await api.helpResponses(query)
    rows.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}
function setPage(page) { query.page = page; load() }
onMounted(load)
</script>

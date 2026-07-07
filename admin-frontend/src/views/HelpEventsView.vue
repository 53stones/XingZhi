<template>
  <DataTable
    title="求助事件"
    subtitle="查看一键求助、自定义求助和 AI 协助求助记录"
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
        <input v-model.trim="query.keyword" placeholder="类型/用户" @keyup.enter="load" />
        <button @click="load">查询</button>
      </div>
    </template>
    <template #cell-helpModeName="{ row }">
      <span :class="['tag', row.helpMode === 1 ? 'danger' : 'ok']">{{ row.helpModeName || '-' }}</span>
    </template>
    <template #cell-statusName="{ row }">
      <span :class="['tag', row.status === 1 ? 'danger' : row.status === 2 ? 'urgent' : row.status === 3 ? 'ok' : 'muted']">{{ row.statusName || '-' }}</span>
    </template>
    <template #cell-emergencyLevelName="{ row }">
      <span :class="['tag', row.emergencyLevel === 1 ? 'warn' : row.emergencyLevel === 2 ? 'urgent' : row.emergencyLevel >= 3 ? 'danger' : 'muted']">{{ row.emergencyLevelName || '-' }}</span>
    </template>
    <template #rowActions="{ row }">
      <button @click="openDetail(row.id)">详情</button>
    </template>
  </DataTable>
  <div v-if="detail" class="drawer">
    <div class="drawer-card">
      <button class="drawer-close" @click="detail = null">×</button>
      <h2>求助详情 #{{ detail.id }}</h2>
      <dl>
        <dt>求助人</dt><dd>{{ detail.requesterName }} / {{ detail.requesterPhone }}</dd>
        <dt>响应人</dt><dd>{{ detail.responderName || '-' }} / {{ detail.responderPhone || '-' }}</dd>
        <dt>描述</dt><dd>{{ detail.description || '-' }}</dd>
        <dt>位置</dt><dd>{{ detail.longitude }}, {{ detail.latitude }}</dd>
        <dt>状态</dt><dd>{{ detail.statusName }}</dd>
        <dt>时间</dt><dd>{{ detail.createTime }}</dd>
      </dl>
    </div>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { api } from '../api/admin'
import DataTable from '../components/DataTable.vue'

const columns = [
  { key: 'id', label: 'ID' },
  { key: 'helpModeName', label: '模式' },
  { key: 'helpType', label: '类型' },
  { key: 'emergencyLevelName', label: '等级' },
  { key: 'requesterName', label: '求助人' },
  { key: 'responderName', label: '响应人' },
  { key: 'statusName', label: '状态' },
  { key: 'createTime', label: '创建时间' }
]
const query = reactive({ page: 1, size: 10, keyword: '' })
const rows = ref([])
const total = ref(0)
const loading = ref(false)
const detail = ref(null)

async function load() {
  loading.value = true
  try {
    const data = await api.helpEvents(query)
    rows.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}
function setPage(page) { query.page = page; load() }
async function openDetail(id) { detail.value = await api.helpEventDetail(id) }
onMounted(load)
</script>

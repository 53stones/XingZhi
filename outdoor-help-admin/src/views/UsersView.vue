<template>
  <DataTable
    title="用户管理"
    subtitle="查看 App 用户状态并进行启用/禁用"
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
        <input v-model.trim="query.keyword" placeholder="用户名/昵称/手机号" @keyup.enter="load" />
        <button @click="load">查询</button>
      </div>
    </template>
    <template #cell-status="{ row }">
      <span :class="['tag', row.status === 1 ? 'ok' : 'danger']">{{ row.status === 1 ? '正常' : '禁用' }}</span>
    </template>
    <template #cell-isHelper="{ row }">
      <span :class="['tag', row.isHelper === 1 ? 'ok' : 'muted']">{{ row.isHelper === 1 ? '接收' : '关闭' }}</span>
    </template>
    <template #rowActions="{ row }">
      <button v-if="row.status === 1" class="danger-btn" @click="disable(row.id)">禁用</button>
      <button v-else @click="enable(row.id)">启用</button>
    </template>
  </DataTable>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { api } from '../api/admin'
import DataTable from '../components/DataTable.vue'

const columns = [
  { key: 'id', label: 'ID' },
  { key: 'username', label: '用户名' },
  { key: 'nickname', label: '昵称' },
  { key: 'phone', label: '手机号' },
  { key: 'status', label: '状态' },
  { key: 'isHelper', label: '互助' },
  { key: 'createTime', label: '创建时间' }
]
const query = reactive({ page: 1, size: 10, keyword: '' })
const rows = ref([])
const total = ref(0)
const loading = ref(false)

async function load() {
  loading.value = true
  try {
    const data = await api.users(query)
    rows.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}
function setPage(page) { query.page = page; load() }
async function enable(id) { await api.enableUser(id); load() }
async function disable(id) { await api.disableUser(id); load() }
onMounted(load)
</script>

<template>
  <DataTable
    title="管理员"
    subtitle="仅超级管理员可管理后台账号"
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
        <input v-model.trim="query.keyword" placeholder="账号/昵称" @keyup.enter="load" />
        <button @click="load">查询</button>
        <button @click="showCreate = !showCreate">新建</button>
      </div>
    </template>
    <template #cell-status="{ row }">
      <span :class="['tag', row.status === 1 ? 'ok' : 'danger']">{{ row.status === 1 ? '正常' : '禁用' }}</span>
    </template>
    <template #rowActions="{ row }">
      <button v-if="row.status === 1" class="danger-btn" @click="disable(row.id)">禁用</button>
      <button v-else @click="enable(row.id)">启用</button>
      <button @click="resetPassword(row.id)">重置密码</button>
    </template>
  </DataTable>

  <section v-if="showCreate" class="panel form-panel">
    <h2>新建管理员</h2>
    <div class="form-grid">
      <input v-model.trim="form.username" placeholder="用户名" />
      <input v-model.trim="form.nickname" placeholder="昵称" />
      <input v-model.trim="form.password" type="password" placeholder="初始密码" />
      <button @click="create">创建</button>
    </div>
  </section>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { api } from '../api/admin'
import DataTable from '../components/DataTable.vue'

const columns = [
  { key: 'id', label: 'ID' },
  { key: 'username', label: '用户名' },
  { key: 'nickname', label: '昵称' },
  { key: 'role', label: '角色' },
  { key: 'status', label: '状态' },
  { key: 'createTime', label: '创建时间' }
]
const query = reactive({ page: 1, size: 10, keyword: '' })
const form = reactive({ username: '', nickname: '', password: '' })
const rows = ref([])
const total = ref(0)
const loading = ref(false)
const showCreate = ref(false)
async function load() {
  loading.value = true
  try {
    const data = await api.admins(query)
    rows.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}
function setPage(page) { query.page = page; load() }
async function create() { await api.createAdmin(form); Object.assign(form, { username: '', nickname: '', password: '' }); showCreate.value = false; load() }
async function enable(id) { await api.enableAdmin(id); load() }
async function disable(id) { await api.disableAdmin(id); load() }
async function resetPassword(id) {
  const newPassword = window.prompt('请输入新密码')
  if (newPassword) {
    await api.resetAdminPassword(id, { newPassword })
  }
}
onMounted(load)
</script>

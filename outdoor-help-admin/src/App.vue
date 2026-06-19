<template>
  <LoginView v-if="route === 'login'" @login="go('dashboard')" />
  <div v-else class="shell">
    <aside class="sidebar">
      <div class="brand">
        <div class="brand-mark">行</div>
        <div>
          <strong>行智后台</strong>
          <span>Outdoor Safety Console</span>
        </div>
      </div>
      <nav>
        <button v-for="item in menus" :key="item.key" :class="{ active: route === item.key }" @click="go(item.key)">
          <span>{{ item.icon }}</span>
          {{ item.label }}
        </button>
      </nav>
      <div class="admin-card">
        <strong>{{ admin.nickname || admin.username || '管理员' }}</strong>
        <span>{{ admin.role || 'ADMIN' }}</span>
        <button @click="logout">退出登录</button>
      </div>
    </aside>
    <main class="main">
      <header class="topbar">
        <div>
          <h1>{{ currentTitle }}</h1>
          <p>管理用户、求助事件、响应记录与系统运行状态</p>
        </div>
        <div class="status-pill">后端 /admin API</div>
      </header>
      <DashboardView v-if="route === 'dashboard'" />
      <UsersView v-else-if="route === 'users'" />
      <HelpEventsView v-else-if="route === 'helpEvents'" />
      <HelpResponsesView v-else-if="route === 'responses'" />
      <NotifyRecordsView v-else-if="route === 'notifies'" />
      <AdminsView v-else-if="route === 'admins'" />
    </main>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import LoginView from './views/LoginView.vue'
import DashboardView from './views/DashboardView.vue'
import UsersView from './views/UsersView.vue'
import HelpEventsView from './views/HelpEventsView.vue'
import HelpResponsesView from './views/HelpResponsesView.vue'
import NotifyRecordsView from './views/NotifyRecordsView.vue'
import AdminsView from './views/AdminsView.vue'
import { clearSession, getAdmin, getToken } from './api/request'

const menus = [
  { key: 'dashboard', label: '数据总览', icon: '▦' },
  { key: 'users', label: '用户管理', icon: '◉' },
  { key: 'helpEvents', label: '求助事件', icon: '!' },
  { key: 'responses', label: '响应记录', icon: '↗' },
  { key: 'notifies', label: '通知记录', icon: '✉' },
  { key: 'admins', label: '管理员', icon: '◎' }
]

const route = ref('dashboard')
const admin = ref(getAdmin())

const currentTitle = computed(() => menus.find((item) => item.key === route.value)?.label || '后台管理')

function go(key) {
  route.value = key
  window.location.hash = `#/${key}`
}

function logout() {
  clearSession()
  admin.value = {}
  go('login')
}

function syncRoute() {
  const key = window.location.hash.replace('#/', '') || 'dashboard'
  route.value = getToken() ? key : 'login'
  admin.value = getAdmin()
}

onMounted(() => {
  syncRoute()
  window.addEventListener('hashchange', syncRoute)
})
</script>

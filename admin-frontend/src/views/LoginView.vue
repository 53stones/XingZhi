<template>
  <div class="login-page">
    <section class="login-panel">
      <div class="login-brand">
        <div class="brand-mark big">行</div>
        <h1>行智后台管理</h1>
        <p>户外安全互助平台运营控制台</p>
      </div>
      <form class="login-form" @submit.prevent="submit">
        <label>用户名</label>
        <input v-model.trim="form.username" placeholder="请输入管理员账号" />
        <label>密码</label>
        <input v-model.trim="form.password" type="password" placeholder="请输入密码" />
        <p v-if="error" class="form-error">{{ error }}</p>
        <button :disabled="loading">{{ loading ? '登录中...' : '登录' }}</button>
      </form>
    </section>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { api } from '../api/admin'
import { setSession } from '../api/request'

const emit = defineEmits(['login'])
const loading = ref(false)
const error = ref('')
const form = reactive({ username: '', password: '' })

async function submit() {
  if (!form.username || !form.password) {
    error.value = '请输入用户名和密码'
    return
  }
  loading.value = true
  error.value = ''
  try {
    const data = await api.login(form)
    setSession(data)
    emit('login')
    window.location.hash = '#/dashboard'
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}
</script>

const TOKEN_KEY = 'xingzhi_admin_token'
const ADMIN_KEY = 'xingzhi_admin_profile'

export function getToken() {
  return localStorage.getItem(TOKEN_KEY) || ''
}

export function setSession(data) {
  localStorage.setItem(TOKEN_KEY, data.token || '')
  localStorage.setItem(ADMIN_KEY, JSON.stringify(data || {}))
}

export function clearSession() {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(ADMIN_KEY)
}

export function getAdmin() {
  try {
    return JSON.parse(localStorage.getItem(ADMIN_KEY) || '{}')
  } catch {
    return {}
  }
}

export async function request(path, options = {}) {
  const headers = new Headers(options.headers || {})
  const token = getToken()
  if (token) headers.set('Authorization', `Bearer ${token}`)

  let body = options.body
  if (body && !(body instanceof FormData)) {
    headers.set('Content-Type', 'application/json')
    body = JSON.stringify(body)
  }

  const response = await fetch(path, { ...options, headers, body })
  if (response.status === 401) {
    clearSession()
    window.location.hash = '#/login'
    throw new Error('登录已过期')
  }
  const result = await response.json().catch(() => ({}))
  if (!response.ok || result.code !== 200) {
    throw new Error(result.msg || `请求失败 ${response.status}`)
  }
  return result.data
}

export function toQuery(params = {}) {
  const search = new URLSearchParams()
  Object.entries(params).forEach(([key, value]) => {
    if (value !== undefined && value !== null && value !== '') {
      search.append(key, value)
    }
  })
  const query = search.toString()
  return query ? `?${query}` : ''
}

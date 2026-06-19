import { request, toQuery } from './request'

export const api = {
  login: (payload) => request('/admin/login', { method: 'POST', body: payload }),
  overview: () => request('/admin/stat/overview'),
  users: (params) => request(`/admin/users${toQuery(params)}`),
  userDetail: (id) => request(`/admin/users/${id}`),
  enableUser: (id) => request(`/admin/users/${id}/enable`, { method: 'PUT' }),
  disableUser: (id) => request(`/admin/users/${id}/disable`, { method: 'PUT' }),
  helpEvents: (params) => request(`/admin/help-events${toQuery(params)}`),
  helpEventDetail: (id) => request(`/admin/help-events/${id}`),
  helpResponses: (params) => request(`/admin/help-responses${toQuery(params)}`),
  notifyRecords: (params) => request(`/admin/help-notify-records${toQuery(params)}`),
  admins: (params) => request(`/admin/admins${toQuery(params)}`),
  createAdmin: (payload) => request('/admin/admins', { method: 'POST', body: payload }),
  enableAdmin: (id) => request(`/admin/admins/${id}/enable`, { method: 'PUT' }),
  disableAdmin: (id) => request(`/admin/admins/${id}/disable`, { method: 'PUT' }),
  resetAdminPassword: (id, payload) => request(`/admin/admins/${id}/reset-password`, { method: 'PUT', body: payload })
}

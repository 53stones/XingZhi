<template>
  <section class="panel">
    <div class="panel-head">
      <div>
        <h2>{{ title }}</h2>
        <p v-if="subtitle">{{ subtitle }}</p>
      </div>
      <slot name="actions" />
    </div>
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th v-for="column in columns" :key="column.key">{{ column.label }}</th>
            <th v-if="$slots.rowActions">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td :colspan="columns.length + ($slots.rowActions ? 1 : 0)" class="empty">加载中...</td>
          </tr>
          <tr v-else-if="!rows.length">
            <td :colspan="columns.length + ($slots.rowActions ? 1 : 0)" class="empty">暂无数据</td>
          </tr>
          <tr v-for="row in rows" :key="row.id || JSON.stringify(row)">
            <td v-for="column in columns" :key="column.key">
              <slot :name="`cell-${column.key}`" :row="row">
                {{ row[column.key] ?? '-' }}
              </slot>
            </td>
            <td v-if="$slots.rowActions">
              <slot name="rowActions" :row="row" />
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="pagination">
      <span>共 {{ total }} 条</span>
      <button :disabled="page <= 1" @click="$emit('page', page - 1)">上一页</button>
      <strong>{{ page }}</strong>
      <button :disabled="page * size >= total" @click="$emit('page', page + 1)">下一页</button>
    </div>
  </section>
</template>

<script setup>
defineProps({
  title: { type: String, required: true },
  subtitle: { type: String, default: '' },
  columns: { type: Array, required: true },
  rows: { type: Array, required: true },
  total: { type: Number, default: 0 },
  page: { type: Number, default: 1 },
  size: { type: Number, default: 10 },
  loading: { type: Boolean, default: false }
})
defineEmits(['page'])
</script>

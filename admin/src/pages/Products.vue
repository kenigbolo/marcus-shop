<template>
  <div>
    <h1 class="text-2xl font-bold text-indigo-700 mb-4">Products</h1>

    <div v-if="loading" class="text-sm text-gray-500">Loading...</div>
    <div v-else>
      <table class="w-full table-auto border rounded">
        <thead class="bg-indigo-100 text-left text-sm text-indigo-700">
          <tr>
            <th class="p-2 border-b">Name</th>
            <th class="p-2 border-b">Category</th>
            <th class="p-2 border-b">Active?</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="product in products" :key="product.id" class="text-sm">
            <td class="p-2 border-b">{{ product.name }}</td>
            <td class="p-2 border-b">{{ product.category }}</td>
            <td class="p-2 border-b">
              <span :class="product.is_active ? 'text-green-600' : 'text-gray-500'">
                {{ product.is_active ? 'Yes' : 'No' }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../api'

const products = ref([])
const loading = ref(true)

onMounted(async () => {
  try {
    const res = await api.get('/products')
    products.value = res.data
  } catch (err) {
    console.error('Failed to load products', err)
  } finally {
    loading.value = false
  }
})
</script>

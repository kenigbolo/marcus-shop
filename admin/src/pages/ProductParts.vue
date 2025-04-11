<template>
  <div>
    <h1 class="text-2xl font-bold text-indigo-700 mb-4">
      Parts for: {{ product?.name || 'Loading...' }}
    </h1>

    <div v-if="loading" class="text-gray-500 text-sm">Loading parts...</div>

    <div v-else>
      <div
        v-for="part in product.parts"
        :key="part.id"
        class="bg-white p-4 rounded shadow mb-4"
      >
        <h2 class="text-lg font-semibold mb-2">{{ part.name }}</h2>
        <ul class="text-sm text-gray-700 list-disc ml-5">
          <li
            v-for="opt in part.part_options"
            :key="opt.id"
            class="mb-1"
          >
            {{ opt.name }} — €{{ opt.base_price }} 
            <span
              :class="opt.stock_status === 'available' ? 'text-green-600' : 'text-gray-400'"
              class="ml-2 text-xs uppercase"
            >
              ({{ opt.stock_status }})
            </span>
          </li>
        </ul>
      </div>
    </div>

    <RouterLink to="/products" class="text-indigo-500 hover:underline text-sm">
      ← Back to products
    </RouterLink>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '../api'

const route = useRoute()
const productId = route.params.id
const product = ref(null)
const loading = ref(true)

const fetchParts = async () => {
  try {
    const res = await api.get(`/products/${productId}`)
    product.value = res.data
  } catch (err) {
    console.error('Failed to load product parts', err)
  } finally {
    loading.value = false
  }
}

onMounted(fetchParts)
</script>

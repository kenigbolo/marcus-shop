<template>
  <div class="p-4">
    <!-- <h1 class="text-2xl font-bold mb-4">Conditional Prices</h1> -->
    <h1 class="text-xl font-semibold mb-4 text-indigo-700">
      Conditional Prices for: 
      <span class="font-bold text-gray-800">{{ optionName }}</span>
    </h1>
    

    <table class="w-full text-left border mb-6">
      <thead>
        <tr>
          <th class="p-2 border-b">Context Option</th>
          <th class="p-2 border-b">Price Override (€)</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="price in prices" :key="price.id">
          <td class="p-2 border-b">{{ findOptionName(price.context_option_id) }}</td>
          <td class="p-2 border-b">{{ price.price_override }}</td>
        </tr>
      </tbody>
    </table>

    <hr class="my-6" />

    <h3 class="text-lg font-medium mb-2">Add Conditional Price</h3>

    <form @submit.prevent="createPrice" class="space-y-4 max-w-md">
      <div>
        <label class="block text-sm font-medium">Context Option</label>
        <select
          v-model="newPrice.context_option_id"
          class="mt-1 block w-full border rounded px-2 py-1 text-sm"
          required
        >
          <option disabled value="">-- Select an option --</option>
          <option
            v-for="opt in contextOptions"
            :key="opt.id"
            :value="opt.id"
          >
            {{ opt.name }}
          </option>
        </select>
      </div>

      <div>
        <label class="block text-sm font-medium">Price Override (€)</label>
        <input
          v-model="newPrice.price_override"
          type="number"
          step="0.01"
          min="0"
          class="mt-1 block w-full border rounded px-2 py-1 text-sm"
          required
        />
      </div>

      <button
        type="submit"
        class="bg-indigo-600 text-white text-sm px-4 py-2 rounded hover:bg-indigo-700"
      >
        Create
      </button>

      <p v-if="formError" class="text-sm text-red-600 mt-2">{{ formError }}</p>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '../api'

const route = useRoute()
const optionId = route.params.option_id
const partId = route.params.part_id
const optionName = route.query.optionName || 'Unknown'
const prices = ref([])
const contextOptions = ref([])
const newPrice = ref({
  context_option_id: '',
  price_override: ''
})
const formError = ref(null)

const fetchPrices = async () => {
  const url = `http://localhost:3000/api/part_options/${optionId}/conditional_prices`
  const res = await api.get(url)
  prices.value = res.data
}

const fetchContextOptions = async () => {
  try {
    const res = await api.get(`http://localhost:3000/api/parts/${partId}/part_options`)
    const options = res.data
    contextOptions.value = options.filter(opt => opt.id !== Number(optionId))
  } catch {
    contextOptions.value = []
  }
}

const findOptionName = (id) => {
  const match = contextOptions.value.find(opt => opt.id === id)
  return match ? match.name : '(unknown)'
}

const createPrice = async () => {
  formError.value = null
  const url = `http://localhost:3000/api/part_options/${optionId}/conditional_prices`
  try {
    const res = await api.post(url, { conditional_price: newPrice.value })
    const created = res.data
    prices.value.push(created)
    newPrice.value = { context_option_id: '', price_override: '' }
  } catch (err) {
    err.response?.data?.errors
      ? formError.value = `${err.response.data.errors[0]}. ${err.response.data.errors[1]}`
      : formError.value = err.message
  }
}

onMounted(() => {
  fetchPrices()
  fetchContextOptions()
})
</script>

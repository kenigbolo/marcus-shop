<template>
  <div class="max-w-2xl mx-auto mt-8">
    <RouterLink :to="`/products/${productId}/parts`" class="text-indigo-500 hover:underline text-sm">
      ← Back to parts
    </RouterLink>
    <h1 class="text-2xl font-bold mb-4 text-indigo-700">
      Conditional Prices for: <span class="italic text-gray-600">{{ optionName }}</span>
    </h1>

    <!-- Form -->
    <form @submit.prevent="savePrice" class="space-y-4 p-4 bg-white rounded shadow border border-gray-200">
      <div>
        <label class="block text-sm font-medium mb-1 text-gray-700">Context Option</label>
        <select v-model="selectedOptionId" class="w-full border rounded p-2">
          <option disabled value="">-- Select Option --</option>
          <option v-for="option in partOptions" :key="option.id" :value="option.id">
            {{ option.name }}
          </option>
        </select>
      </div>

      <div>
        <label class="block text-sm font-medium mb-1 text-gray-700">Price Override (€)</label>
        <input
          type="number"
          v-model="priceOverride"
          step="0.01"
          class="w-full border rounded p-2"
          required
        />
      </div>

      <div class="flex items-center space-x-3">
        <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700">
          {{ isEditing ? 'Update Price' : 'Add Price' }}
        </button>
        <button
          v-if="isEditing"
          type="button"
          class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400"
          @click="resetForm"
        >
          Cancel
        </button>
      </div>
    </form>

    <!-- Price List -->
    <table class="w-full mt-6 text-left border border-gray-200">
      <thead class="bg-gray-100 text-gray-700">
        <tr>
          <th class="p-2 border">Context Option</th>
          <th class="p-2 border">Override Price</th>
          <th class="p-2 border">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="price in conditionalPrices" :key="price.id">
          <td class="p-2 border">{{ getOptionName(price.context_option_id) }}</td>
          <td class="p-2 border">€{{ price.price_override }}</td>
          <td class="p-2 border space-x-2">
            <button
              class="bg-yellow-400 hover:bg-yellow-500 text-white px-3 py-1 rounded text-sm"
              @click="startEdit(price)"
            >
              Edit
            </button>
            <button
              class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-sm"
              @click="deletePrice(price.id)"
            >
              Delete
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { toast } from 'vue-sonner'
import { useRoute } from 'vue-router'
import api from '../api'

const route = useRoute()
const optionId = ref(route.params.option_id)
const partId = ref(route.params.part_id)
const productId = route.query.productId
const optionName = route.query.optionName || 'Unnamed Option'

const partOptions = ref([])
const conditionalPrices = ref([])

const selectedOptionId = ref('')
const priceOverride = ref('')
const isEditing = ref(false)
const editTarget = ref(null)
const url = ref('http://localhost:3000/api')

async function fetchPartOptions() {
  const res = await api.get(`${url.value}/parts/${partId.value}/part_options`)
  const options = res.data
  partOptions.value = options.filter(opt => opt.id !== Number(optionId.value))
}

async function fetchPrices() {
  const res = await api.get(`${url.value}/part_options/${optionId.value}/conditional_prices`)
  conditionalPrices.value = res.data
}

async function savePrice() {
  const payload = {
    context_option_id: selectedOptionId.value,
    price_override: priceOverride.value
  }

  try {
    if (isEditing.value && editTarget.value) {
      await api.patch(`${url.value}/conditional_prices/${editTarget.value.id}`, payload)
    } else {
      await api.post(`${url.value}/part_options/${optionId.value}/conditional_prices`, payload)
    }
    await fetchPrices()
    resetForm()
    toast.success('Conditional price updated')
  } catch (error) {
    console.error(error)
    toast.error('Failed to save conditional price')
  }
}

function startEdit(price) {
  isEditing.value = true
  editTarget.value = { ...price }
  selectedOptionId.value = price.context_option_id
  priceOverride.value = price.price_override
}

function resetForm() {
  selectedOptionId.value = ''
  priceOverride.value = ''
  isEditing.value = false
  editTarget.value = null
}

async function deletePrice(id) {
  if (!confirm('Are you sure you want to delete this conditional price?')) return
  try {
    await api.delete(`${url.value}/conditional_prices/${id}`)
    await fetchPrices()
    toast.success('Conditional price deleted successfully')
  } catch (error) {
    console.error(error)
    toast.error('Failed to delete conditional price')
  }
}

function getOptionName(id) {
  const found = partOptions.value.find(o => o.id === id)
  return found ? found.name : 'N/A'
}

onMounted(async () => {
  await Promise.all([fetchPartOptions(), fetchPrices()])
})
</script>

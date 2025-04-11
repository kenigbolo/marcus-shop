<template>
  <div>
    <h1 class="text-2xl font-bold text-indigo-700 mb-4">
      Parts for: {{ product?.name || 'Loading...' }}
    </h1>
    <!-- New Part Form -->
    <div class="mb-6 p-4 bg-white rounded shadow border max-w-md">
      <h2 class="text-lg font-semibold mb-2">Add New Part</h2>
      <form @submit.prevent="createPart" class="space-y-4">
        <input
          v-model="newPartName"
          placeholder="e.g., Frame, Wheels, Chain"
          class="input"
          required
        />
        <button
          type="submit"
          class="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700"
        >
          Add Part
        </button>
      </form>
    </div>

    <div v-if="loading" class="text-gray-500 text-sm">Loading parts...</div>

    <div v-else>
      <div
        v-for="part in product.parts"
        :key="part.id"
        class="bg-white p-4 rounded shadow mb-4"
      >
        <!-- Part Name -->
        <h2 class="text-lg font-semibold mb-2">{{ part.name }}</h2>
        <!-- Existing Options -->
        <ul class="text-sm text-gray-700 list-disc ml-5">
          <li v-for="opt in part.part_options || []" :key="opt.id" class="mb-2 bg-gray-50 p-2 rounded border">
            <template v-if="editingOption[opt.id]">
              <form @submit.prevent="saveOption(opt.id)" class="grid grid-cols-1 md:grid-cols-5 gap-2 text-sm items-center">
                <input
                  v-model="editingOption[opt.id].name"
                  class="input"
                  placeholder="Option Name"
                  required
                />
                <input
                  type="number"
                  v-model="editingOption[opt.id].base_price"
                  class="input"
                  placeholder="Base Price"
                  required
                />
                <select v-model="editingOption[opt.id].stock_status" class="input">
                  <option value="available">Available</option>
                  <option value="out_of_stock">Out of Stock</option>
                </select>
                <button type="submit" class="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700">
                  Save
                </button>
                <button
                  type="button"
                  @click="cancelEditOption(opt.id)"
                  class="text-gray-600 hover:text-gray-800"
                >
                  Cancel
                </button>
              </form>
            </template>
          
            <template v-else>
              {{ opt.name }} — €{{ opt.base_price }}
              <span
                :class="opt.stock_status === 'available' ? 'text-green-600' : 'text-gray-400'"
                class="ml-2 text-xs uppercase"
              >
                ({{ opt.stock_status }})
              </span>
              <button @click="startEditOption(opt)" class="text-indigo-500 text-xs ml-2">Edit</button>
              <button @click="deleteOption(opt.id)" class="text-red-500 text-xs ml-2">Delete</button>
            </template>
          </li>
        </ul>
        <!-- Add New Option Part Form -->
        <div class="mt-4 p-3 border border-gray-200 rounded bg-gray-50">
          <h3 class="text-sm font-semibold mb-2">Add Option</h3>
          <form @submit.prevent="createOption(part.id)" class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
            <input
              v-model="newOptions[part.id].name"
              placeholder="Option Name"
              class="input"
              required
            />
            <input
              type="number"
              v-model="newOptions[part.id].base_price"
              placeholder="Base Price"
              class="input"
              required
            />
            <select v-model="newOptions[part.id].stock_status" class="input">
              <option value="available">Available</option>
              <option value="out_of_stock">Out of Stock</option>
            </select>
            <button
              type="submit"
              class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 col-span-1 md:col-span-3"
            >
              Add Option
            </button>
          </form>
        </div>
        <!-- End New Option Part Form -->
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
import { toast } from 'vue-sonner'
import api from '../api'

const route = useRoute()
const productId = route.params.id
const product = ref(null)
const loading = ref(true)

const newPartName = ref('')
const newOptions = ref({}) // keyed by part.id
const editingOption = ref({}) // keyed by option.id


const createPart = async () => {
  if (!newPartName.value.trim()) return
  try {
    await api.post(`/products/${productId}/parts`, {
      part: { name: newPartName.value }
    })
    newPartName.value = ''
    toast.success('Part added')
    await fetchParts()
  } catch (err) {
    console.error('Failed to create part', err)
    toast.error('Could not add part')
  }
}

const fetchParts = async () => {
  try {
    const res = await api.get(`/products/${productId}`)
    product.value = res.data
  } catch (err) {
    toast.error('Failed to load product parts')
    console.error('Failed to load product parts', err)
  } finally {
    loading.value = false
  }
}

const createOption = async (partId) => {
  const payload = newOptions.value[partId]
  if (!payload?.name || payload.base_price === undefined) return

  try {
    await api.post(`/parts/${partId}/part_options`, {
      part_option: {
        name: payload.name,
        base_price: parseFloat(payload.base_price),
        stock_status: payload.stock_status || 'available'
      }
    })
    toast.success('Option added')
    newOptions.value[partId] = { name: '', base_price: '', stock_status: 'available' }
    await fetchParts()
  } catch (err) {
    console.error('Failed to create option', err)
    toast.error('Could not add option')
  }
}

const startEditOption = (opt) => {
  editingOption.value[opt.id] = {
    name: opt.name,
    base_price: opt.base_price,
    stock_status: opt.stock_status
  }
}

const cancelEditOption = (id) => {
  delete editingOption.value[id]
}

const saveOption = async (id) => {
  const payload = editingOption.value[id]
  try {
    await api.put(`/part_options/${id}`, {
      part_option: {
        name: payload.name,
        base_price: parseFloat(payload.base_price),
        stock_status: payload.stock_status
      }
    })
    toast.success('Option updated')
    await fetchParts()
    cancelEditOption(id)
  } catch (err) {
    console.error('Failed to update option', err)
    toast.error('Failed to save changes')
  }
}

const deleteOption = async (id) => {
  if (!confirm('Delete this option?')) return

  try {
    await api.delete(`/part_options/${id}`)
    toast.success('Option deleted')
    await fetchParts()
  } catch (err) {
    console.error('Failed to delete option', err)
    toast.error('Failed to delete')
  }
}


onMounted(() => {
  fetchParts().then(() => {
    product.value?.parts?.forEach(part => {
      newOptions.value[part.id] = { name: '', base_price: '', stock_status: 'available' }
    })
  })
})

</script>

<style scoped>
.input {
  display: block;
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 0.375rem;
  font-size: 0.875rem;
}
</style>
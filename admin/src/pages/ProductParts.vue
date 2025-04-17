<template>
  <div>
    <RouterLink to="/products" class="text-indigo-500 hover:underline text-sm">
      ← Back to products
    </RouterLink>
    <h1 class="text-2xl font-bold text-indigo-700 mb-4">
      Parts for: {{ product?.name || 'Loading...' }}
    </h1>

    <!-- New Part Form -->
    <div class="mb-6 p-4 bg-white rounded shadow border max-w-md">
      <h2 class="text-lg font-semibold mb-2">Add New Part</h2>
      <form @submit.prevent="createPart" class="space-y-4">
        <label for="newPartName" class="block text-sm font-medium text-gray-700">Part Name</label>
        <input
          id="newPartName"
          v-model="newPartName"
          placeholder="e.g., Frame, Wheels, Chain"
          class="input"
          required
        />
        <button
          type="submit"
          class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700"
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
        <div class="flex justify-between items-center mb-2">
          <template v-if="editingPart === part.id">
            <label :for="`edit-part-${part.id}`" class="sr-only">Part name</label>
            <input
              :id="`edit-part-${part.id}`"
              v-model="editedPartName"
              class="input w-full max-w-xs"
              placeholder="Part name"
            />
            <div class="ml-4 flex gap-2">
              <button
                @click="saveEditPart(part.id)"
                class="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700 text-sm"
              >
                Save
              </button>
              <button
                @click="cancelEditPart"
                class="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600 text-sm"
              >
                Cancel
              </button>
            </div>
          </template>
          <template v-else>
            <h2 class="text-lg font-semibold">{{ part.name }}</h2>
            <div class="flex gap-2">
              <button
                @click="startEditPart(part)"
                class="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600 text-xs"
              >
                Edit
              </button>
              <button
                @click="deletePart(part.id)"
                class="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700 text-xs"
              >
                Delete
              </button>
            </div>
          </template>
        </div>

        <!-- Existing Options -->
        <ul class="grid gap-3">
          <li
            v-for="opt in part.part_options || []"
            :key="opt.id"
            class="p-3 rounded border shadow-sm bg-gray-50"
          >
            <template v-if="editingOption[opt.id]">
              <form @submit.prevent="saveOption(opt.id)" class="grid grid-cols-1 md:grid-cols-5 gap-2 items-center text-sm">
                <div>
                  <label :for="`edit-name-${opt.id}`" class="block text-xs font-medium text-gray-600">Name</label>
                  <input id="edit-name-${opt.id}" v-model="editingOption[opt.id].name" class="input" required />
                </div>
                <div>
                  <label :for="`edit-price-${opt.id}`" class="block text-xs font-medium text-gray-600">Price</label>
                  <input id="edit-price-${opt.id}" type="number" v-model="editingOption[opt.id].base_price" class="input" required />
                </div>
                <div>
                  <label :for="`edit-stock-${opt.id}`" class="block text-xs font-medium text-gray-600">Stock</label>
                  <input id="edit-stock-${opt.id}" type="number" min="0" v-model="editingOption[opt.id].stock_count" class="input" required />
                </div>
                <div>
                  <label :for="`edit-status-${opt.id}`" class="block text-xs font-medium text-gray-600">Status</label>
                  <select id="edit-status-${opt.id}" v-model="editingOption[opt.id].stock_status" class="input">
                    <option value="available">Available</option>
                    <option value="out_of_stock">Out of Stock</option>
                  </select>
                </div>
                <div class="flex gap-2">
                  <button type="submit" class="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700">Save</button>
                  <button type="button" @click="cancelEditOption(opt.id)" class="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600">
                    Cancel
                  </button>
                </div>
              </form>
            </template>
            <template v-else>
              <div class="flex justify-between items-start">
                <div>
                  <p class="font-medium text-gray-800">
                    {{ opt.name }} — €{{ opt.base_price }}
                    <span
                      class="ml-2 text-xs uppercase"
                      :class="opt.stock_status === 'available' ? 'text-green-600' : 'text-gray-400'"
                    >
                      ({{ opt.stock_status }})
                    </span>
                    <span v-if="opt.stock_count >= 0" class="ml-2 text-xs text-gray-700">
                      • {{ opt.stock_count }} in stock
                    </span>
                    <span v-if="opt.stock_count < 3" class="ml-2 text-xs text-red-600 font-semibold">
                      🔴 Low stock
                    </span>
                  </p>
                  <router-link
                    :to="{
                      path: `/part/${part.id}/option/${opt.id}/conditional-prices`,
                      query: { optionName: opt.name, productId }
                    }"
                    class="text-indigo-600 hover:underline text-xs"
                  >
                    Set Conditional Prices
                  </router-link>
                </div>
                <div class="flex gap-2">
                  <button @click="startEditOption(opt)" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600 text-xs">
                    Edit
                  </button>
                  <button @click="deleteOption(opt.id)" class="bg-red-600 text-white px-2 py-1 rounded hover:bg-red-700 text-xs">
                    Delete
                  </button>
                </div>
              </div>
            </template>
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
import { toast } from 'vue-sonner'
import api from '../api'

const route = useRoute()
const productId = route.params.id
const product = ref(null)
const loading = ref(true)

const newPartName = ref('')
const newOptions = ref({}) // keyed by part.id
const editingOption = ref({}) // keyed by option.id
const editingPart = ref(null) // part.id
const editedPartName = ref('')

// Create Part
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

// Start Editing Parts function
const startEditPart = (part) => {
  editingPart.value = part.id
  editedPartName.value = part.name
}

const cancelEditPart = () => {
  editingPart.value = null
  editedPartName.value = ''
}

const saveEditPart = async (partId) => {
  try {
    await api.put(`/parts/${partId}`, {
      part: { name: editedPartName.value }
    })
    toast.success('Part updated')
    await fetchParts()
    cancelEditPart()
  } catch (err) {
    toast.error('Failed to update part')
    console.error('Failed to update part', err)
  }
}
// End editing parts functions

// Delete Part
const deletePart = async (partId) => {
  if (!confirm('Are you sure you want to delete this part?')) return

  try {
    await api.delete(`/parts/${partId}`)
    toast.success('Part deleted')
    await fetchParts()
  } catch (err) {
    toast.error('Failed to delete part')
    console.error('Error deleting part:', err)
  }
}

// Fetch Parts
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
  // Client side validation
  if (!payload?.name || payload.base_price === undefined) return
  if (payload.stock_count < 0) {
    toast.error('Stock count cannot be negative')
    return
  }
  // Trigger api call
  try {
    await api.post(`/parts/${partId}/part_options`, {
      part_option: {
        name: payload.name,
        base_price: parseFloat(payload.base_price),
        stock_status: payload.stock_status || 'available',
        stock_count: parseInt(payload.stock_count || 0, 10)
      }
    })
    toast.success('Option added')
    newOptions.value[partId] = { name: '', base_price: '', stock_status: 'available', stock_count: 0 }
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
    stock_status: opt.stock_status,
    stock_count: opt.stock_count ?? 0
  }
}

const cancelEditOption = (id) => {
  delete editingOption.value[id]
}

const saveOption = async (id) => {
  const payload = editingOption.value[id]
  // Client side validations
  if (!payload?.name || payload.base_price === undefined) return
  if (payload.stock_count < 0) {
    toast.error('Stock count cannot be negative')
    return
  }
  // Trigger api call to save part option
  try {
    await api.put(`/part_options/${id}`, {
      part_option: {
        name: payload.name,
        base_price: parseFloat(payload.base_price),
        stock_status: payload.stock_status,
        stock_count: parseInt(payload.stock_count || 0, 10)
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
      newOptions.value[part.id] = { name: '', base_price: '', stock_status: 'available', stock_count: 0 }
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
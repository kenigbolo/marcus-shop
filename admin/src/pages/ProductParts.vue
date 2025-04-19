<template>
  <div>
    <RouterLink to="/products" class="text-indigo-500 hover:underline text-sm">
      ← Back to products
    </RouterLink>
    <h1 class="text-2xl font-bold text-indigo-700 mb-4">
      Parts for: {{ product?.name || 'Loading...' }}
    </h1>

    <!-- Add Part Tile Component -->
    <AddPartTile 
      :newPartName="newPartName"
      @add="createPart"
      @update:newPartName="val => newPartName = val"
    />


    <div v-if="loading" class="text-gray-500 text-sm">Loading parts...</div>

    <div v-else>
      <PartTile
        v-for="part in product.parts"
        :key="part.id"
        :part="part"
        :editingPart="editingPart"
        :editedPartName="editedPartName"
        :editingOption="editingOption"
        :newOptions="newOptions[part.id] || {}"
        :productId="productId"
        @saveEditPart="saveEditPart"
        @cancelEditPart="cancelEditPart"
        @startEditPart="startEditPart"
        @deletePart="deletePart"
        @startEditOption="startEditOption"
        @cancelEditOption="cancelEditOption"
        @saveOption="saveOption"
        @deleteOption="deleteOption"
        @createOption="createOption"
        @update:editingOption="val => editingOption = val"
        @update:newOptions="(val) => { newOptions[part.id] = val }"
      />
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

import AddPartTile from '../components/ProductParts/AddPartTile.vue'
import PartTile from '../components/ProductParts/PartTile.vue'

const route = useRoute()
const productId = route.params.id
const product = ref(null)
const loading = ref(true)

const newPartName = ref('')
const newOptions = ref({})
const editingOption = ref({})
const editingPart = ref(null)
const editedPartName = ref('')

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

const createOption = async (partId, payload) => {
  if (!payload?.name || payload.base_price === undefined) return
  if (payload.stock_count < 0) {
    toast.error('Stock count cannot be negative')
    return
  }
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
  if (!payload?.name || payload.base_price === undefined) return
  if (payload.stock_count < 0) {
    toast.error('Stock count cannot be negative')
    return
  }
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

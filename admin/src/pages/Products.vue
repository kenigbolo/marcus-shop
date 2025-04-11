<template>
  <div>
    <h1 class="text-2xl font-bold text-indigo-700 mb-4">Products</h1>

    <button
      @click="showForm = !showForm"
      class="mb-4 px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
    >
      {{ showForm ? 'Cancel' : 'Add New Product' }}
    </button>

    <div v-if="showForm" class="mb-6 p-4 bg-white shadow rounded border">
      <h2 class="text-lg font-semibold mb-2">New Product</h2>
      <form @submit.prevent="createProduct" class="space-y-4">
        <input v-model="newProduct.name" placeholder="Name" class="input" required />
        <input v-model="newProduct.category" placeholder="Category" class="input" required />
        <textarea v-model="newProduct.description" placeholder="Description" class="input" rows="3" />
        <label class="block text-sm">
          <input type="checkbox" v-model="newProduct.is_active" class="mr-2" />
          Active
        </label>
        <button
          type="submit"
          class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700"
        >
          Save Product
        </button>
      </form>
    </div>

    <div v-if="loading" class="text-sm text-gray-500">Loading...</div>
    <div v-else>
      <table class="w-full table-auto border rounded">
        <thead class="bg-indigo-100 text-left text-sm text-indigo-700">
          <tr>
            <th class="p-2 border-b">Name</th>
            <th class="p-2 border-b">Category</th>
            <th class="p-2 border-b">Active?</th>
            <th class="p-2 border-b">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="product in products" :key="product.id" class="text-sm">
            <template v-if="editingProduct?.id === product.id">
              <td class="p-2 border-b">
                <input v-model="editingProduct.name" class="input" />
              </td>
              <td class="p-2 border-b">
                <input v-model="editingProduct.category" class="input" />
              </td>
              <td class="p-2 border-b">
                <input type="checkbox" v-model="editingProduct.is_active" />
              </td>
              <td class="p-2 border-b flex gap-2">
                <button @click="saveEdit(product.id)" class="text-green-600">Save</button>
                <button @click="cancelEdit" class="text-gray-500">Cancel</button>
              </td>
            </template>
            <template v-else>
              <td class="p-2 border-b">{{ product.name }}</td>
              <td class="p-2 border-b">{{ product.category }}</td>
              <td class="p-2 border-b">
                <span :class="product.is_active ? 'text-green-600' : 'text-gray-500'">
                  {{ product.is_active ? 'Yes' : 'No' }}
                </span>
              </td>
              <td class="p-2 border-b flex gap-2">
                <button @click="startEdit(product)" class="text-indigo-600 hover:underline">Edit</button>
                <button @click="deleteProduct(product.id)" class="text-red-600 hover:underline">Delete</button>
              </td>
            </template>
          </tr>          
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../api'
import { toast } from 'vue-sonner'

const products = ref([])
const loading = ref(true)
const showForm = ref(false)

const newProduct = ref({
  name: '',
  category: '',
  description: '',
  is_active: true
})

const editingProduct = ref(null)

const startEdit = (product) => {
  editingProduct.value = { ...product } // clone
}

const cancelEdit = () => {
  editingProduct.value = null
}

const saveEdit = async (productId) => {
  try {
    await api.put(`/products/${productId}`, editingProduct.value)
    await fetchProducts()
    editingProduct.value = null
    toast.success('Product updated successfully')
  } catch (err) {
    console.error('Failed to update product', err)
    toast.error('Failed to update product')
  }
}

const deleteProduct = async (productId) => {
  if (!confirm('Are you sure you want to delete this product?')) return

  try {
    await api.delete(`/products/${productId}`)
    await fetchProducts()
    toast.success('Product deleted successfully')
  } catch (err) {
    console.error('Failed to delete product', err)
    toast.error('Failed to delete product')
  }
}

const fetchProducts = async () => {
  loading.value = true
  try {
    const res = await api.get('/products')
    products.value = res.data
  } catch (err) {
    console.error('Failed to load products', err)
  } finally {
    loading.value = false
  }
}

const createProduct = async () => {
  try {
    await api.post('/products', newProduct.value)
    await fetchProducts()
    showForm.value = false
    toast.success(`Product: ${newProduct.value.name} created successfully`)
    newProduct.value = { name: '', category: '', description: '', is_active: true }
  } catch (err) {
    console.error('Failed to create product', err)
    toast.error('Failed to create product')
  }
}

onMounted(fetchProducts)
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

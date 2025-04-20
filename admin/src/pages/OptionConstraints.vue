<template>
  <div class="p-6 bg-white shadow rounded-lg max-w-xl mx-auto">
    <RouterLink :to="`/products/${productId}/parts`" class="text-indigo-500 hover:underline text-sm">
      ← Back to parts
    </RouterLink>

    <h1 class="text-xl font-bold text-indigo-700 mt-4 mb-6">
      Constraints for: {{ optionName || 'Selected Option' }}
    </h1>

    <!-- Constraint Form -->
    <ConstraintForm
      :parts="parts"
      :option-id="optionId"
      @submitted="submitConstraint"
    />



    <!-- Replace this block -->
    <ConstraintList
      :constraints="constraints"
      :parts="parts"
      @delete="deleteConstraint"
      @update="updateConstraint"
    />
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import api from '../api'
import { toast } from 'vue-sonner'
import ConstraintForm from '../components/Constraints/ConstraintForm.vue'
import ConstraintList from '../components/Constraints/ConstraintList.vue'

const route = useRoute()
const optionName = route.query.optionName || ''
const optionId = route.params.option_id
const productId = route.query.productId

const parts = ref([])
const constraints = ref([])
const url = ref('http://localhost:3000/api')

const fetchParts = async () => {
  try {
    const res = await api.get(`${url.value}/products/${productId}`)
    parts.value = res.data.parts || []
  } catch (err) {
    toast.error('Failed to load parts')
    console.error(err)
  }
}

const fetchConstraints = async () => {
  try {
    const res = await api.get(`${url.value}/part_options/${optionId}/constraints`)
    constraints.value = res.data
  } catch (err) {
    toast.error('Failed to fetch constraints')
  }
}

const submitConstraint = async (payload) => {
  try {
    const { data } = await api.post(`${url.value}/part_options/${optionId}/constraints`, {
      option_constraint: payload
    })
    constraints.value.push(data)
    toast.success('Constraint added!')
  } catch (err) {
    const error = err?.response?.data?.errors?.[0]
    error ? toast.error(error) : toast.error('Failed to add constraint')
  }
}

const updateConstraint = async (updatedConstraint) => {
  try {
    const { data } = await api.patch(`${url.value}/option_constraints/${updatedConstraint.id}`, {
      option_constraint: {
        constraint_type: updatedConstraint.constraint_type
      }
    })
    const index = constraints.value.findIndex(c => c.id === updatedConstraint.id)
    if (index !== -1) {
      constraints.value[index] = data
    }
    toast.success("Constraint updated!")
  } catch (err) {
    toast.error("Failed to update constraint")
    console.error(err)
  }
}


const deleteConstraint = async (id) => {
  if (!confirm('Are you sure?')) return
  try {
    await api.delete(`${url.value}/option_constraints/${id}`)
    constraints.value = constraints.value.filter(c => c.id !== id)
    toast.success('Deleted constraint')
  } catch (err) {
    toast.error('Failed to delete constraint')
  }
}

onMounted(() => {
  fetchParts()
  fetchConstraints()
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
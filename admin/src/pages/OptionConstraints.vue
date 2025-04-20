<template>
  <div class="p-6 bg-white shadow rounded-lg max-w-xl mx-auto">
    <RouterLink :to="`/products/${productId}/parts`" class="text-indigo-500 hover:underline text-sm">
      ← Back to parts
    </RouterLink>

    <h1 class="text-xl font-bold text-indigo-700 mt-4 mb-6">
      Constraints for: {{ optionName || 'Selected Option' }}
    </h1>

    <form @submit.prevent="submitConstraint" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Part</label>
        <select v-model="selectedPartId" class="input">
          <option disabled value="">-- Select Part --</option>
          <option
            v-for="part in availableParts"
            :key="part.id"
            :value="part.id"
          >
            {{ part.name }}
          </option>
        </select>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Option</label>
        <select v-model="selectedOptionId" class="input" :disabled="!selectedPartId">
          <option disabled value="">-- Select Option --</option>
          <option
            v-for="option in optionsForSelectedPart"
            :key="option.id"
            :value="option.id"
          >
            {{ option.name }}
          </option>
        </select>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Constraint Type</label>
        <select v-model="constraintType" class="input">
          <option value="prohibits">Prohibits</option>
          <option value="requires">Requires</option>
        </select>
      </div>

      <button
        type="submit"
        class="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700"
      >
        Add Constraint
      </button>
    </form>

    <!-- Existing Constraints -->
    <div v-if="constraints.length">
      <h2 class="text-lg font-semibold mb-2">Current Constraints</h2>
      <ul class="divide-y border rounded">
        <li
          v-for="constraint in constraints"
          :key="constraint.id"
          class="flex justify-between items-center p-3 text-sm"
        >
          <div>
            <span class="font-medium">{{ constraint.constraint_type.toUpperCase() }}</span> → 
            {{ getOptionName(constraint.target_option_id) }}
          </div>
        </li>
      </ul>
    </div>

    <p v-else class="text-sm text-gray-500 italic">No constraints added yet.</p>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import api from '../api'
import { toast } from 'vue-sonner'

const route = useRoute()
const optionName = route.query.optionName || ''
const optionId = route.params.option_id
const productId = route.query.productId

const selectedPartId = ref('')
const selectedOptionId = ref('')
const constraintType = ref('prohibits')

const parts = ref([])
const constraints = ref([])
const url = ref('http://localhost:3000/api')

const fetchParts = async () => {
  try {
    const res = await api.get(`${url.value}/products/${productId}`)
    parts.value = res.data.parts || []
  } catch (err) {
    toast.error('Failed to load parts for constraint')
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

const availableParts = computed(() => {
  // Find the part that includes the source option
  const parentPart = parts.value.find(part =>
    part.part_options.some(option => option.id === optionId)
  )
  // Exclude it from the dropdown
  return parts.value.filter(part => part.id !== parentPart?.id)
})

const optionsForSelectedPart = computed(() => {
  return parts.value.find(part => part.id === selectedPartId.value)?.part_options || []
})

const getOptionName = (id) => {
  const allOptions = parts.value.flatMap(p => p.part_options || [])
  return allOptions.find(opt => opt.id === id)?.name || 'Unknown'
}

const submitConstraint = async () => {
  if (!selectedOptionId.value || !constraintType.value) return

  try {
    const { data } = await api.post(`${url.value}/part_options/${optionId}/constraints`, {
      option_constraint: {
        source_option_id: optionId,
        target_option_id: selectedOptionId.value,
        constraint_type: constraintType.value
      }
    })
    constraints.value.push(data)
    toast.success('Constraint added!')
    // reset
    selectedPartId.value = ''
    selectedOptionId.value = ''
    constraintType.value = 'prohibits'
  } catch (err) {
    console.error(err)
    toast.error('Failed to add constraint')
  }
}

onMounted(() => {
  fetchConstraints()
  fetchParts()
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

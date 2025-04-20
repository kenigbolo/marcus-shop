<template>
  <form @submit.prevent="submit" class="space-y-4">
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
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  parts: Array,
  optionId: [String, Number]
})

const emit = defineEmits(['submitted'])

const selectedPartId = ref('')
const selectedOptionId = ref('')
const constraintType = ref('prohibits')

const parentPart = computed(() =>
  props.parts.find(part =>
    part.part_options.some(opt => opt.id == props.optionId)
  )
)

const availableParts = computed(() =>
  props.parts.filter(part => part.id !== parentPart.value?.id)
)

const optionsForSelectedPart = computed(() => {
  return props.parts.find(part => part.id === selectedPartId.value)?.part_options || []
})

const submit = () => {
  if (!selectedOptionId.value || !constraintType.value) return
  emit('submitted', {
    source_option_id: props.optionId,
    target_option_id: selectedOptionId.value,
    constraint_type: constraintType.value
  })

  // Reset fields
  selectedPartId.value = ''
  selectedOptionId.value = ''
  constraintType.value = 'prohibits'
}
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

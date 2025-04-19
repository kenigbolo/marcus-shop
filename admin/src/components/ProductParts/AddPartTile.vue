<template>
  <div class="mb-6 p-4 bg-white rounded shadow border max-w-md">
    <h2 class="text-lg font-semibold mb-2">Add New Part</h2>
    <form @submit.prevent="$emit('add')" class="space-y-4">
      <label for="newPartName" class="block text-sm font-medium text-gray-700">Part Name</label>
      <input
        id="newPartName"
        v-model="internalPartName"
        @input="$emit('update:newPartName', internalPartName)"
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
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  newPartName: String
})
const internalPartName = ref(props.newPartName || '')
watch(() => props.newPartName, val => internalPartName.value = val)
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
<!-- <template>
  <div class="mb-6 p-4 bg-white rounded shadow border max-w-md">
    <h2 class="text-lg font-semibold mb-2">Add New Part</h2>
    <form @submit.prevent="$emit('add')" class="space-y-4">
      <label for="newPartName" class="block text-sm font-medium text-gray-700">Part Name</label>
      <input
        id="newPartName"
        v-model="internalPartName"
        @input="$emit('update:newPartName', internalPartName)"
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
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  newPartName: String
})
const internalPartName = ref(props.newPartName || '')

watch(() => props.newPartName, val => {
  internalPartName.value = val
})
</script> -->
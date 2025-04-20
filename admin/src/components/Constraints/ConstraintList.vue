<template>
  <div v-if="constraints.length" class="mt-6">
    <h2 class="text-lg font-semibold mb-2">Current Constraints</h2>
    <ul class="divide-y border rounded">
      <li
        v-for="constraint in constraints"
        :key="constraint.id"
        class="flex justify-between items-center p-3 text-sm"
      >
        <div>
          <span class="font-medium">
            <template v-if="editingId === constraint.id">
              <select v-model="editedType" class="border p-1 rounded text-sm">
                <option value="prohibits">PROHIBITS</option>
                <option value="requires">REQUIRES</option>
              </select>
            </template>
            <template v-else>
              {{ constraint.constraint_type.toUpperCase() }}
            </template>
          </span>
          →
          {{ getOptionName(constraint.target_option_id) }}
        </div>
        <div class="flex gap-2">
          <template v-if="editingId === constraint.id">
            <button
              @click="saveEdit(constraint)"
              class="text-xs bg-green-500 hover:bg-green-600 text-white px-2 py-1 rounded"
            >
              Save
            </button>
            <button
              @click="cancelEdit"
              class="text-xs bg-gray-500 hover:bg-gray-600 text-white px-2 py-1 rounded"
            >
              Cancel
            </button>
          </template>
          <template v-else>
            <button
              @click="startEdit(constraint)"
              class="text-xs bg-yellow-500 hover:bg-yellow-600 text-white px-2 py-1 rounded"
            >
              Edit
            </button>
            <button
              @click="$emit('delete', constraint.id)"
              class="text-xs bg-red-500 hover:bg-red-600 text-white px-2 py-1 rounded"
            >
              Delete
            </button>
          </template>
        </div>
      </li>
    </ul>
  </div>

  <p v-else class="text-sm text-gray-500 italic mt-4">No constraints added yet.</p>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  constraints: Array,
  parts: Array
})

const emit = defineEmits(['delete', 'update'])

const editingId = ref(null)
const editedType = ref('')

const startEdit = (constraint) => {
  editingId.value = constraint.id
  editedType.value = constraint.constraint_type
}

const cancelEdit = () => {
  editingId.value = null
  editedType.value = ''
}

const saveEdit = (constraint) => {
  emit('update', {
    ...constraint,
    constraint_type: editedType.value
  })
  cancelEdit()
}

const getOptionName = (id) => {
  const allOptions = props.parts.flatMap(p => p.part_options || [])
  return allOptions.find(opt => opt.id === id)?.name || 'Unknown'
}
</script>

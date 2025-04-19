<template>
  <div class="bg-white p-4 rounded shadow mb-4">
    <div class="flex justify-between items-center mb-2">
      <template v-if="editingPart === part.id">
        <label :for="`edit-part-${part.id}`" class="sr-only">Part name</label>
        <input
          :id="`edit-part-${part.id}`"
          @input="$emit('update:editedPartName', $event.target.value)"
          class="input w-full max-w-xs"
          placeholder="Part name"
        />
        <div class="ml-4 flex gap-2">
          <button @click="$emit('saveEditPart', part.id)" class="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700 text-sm">Save</button>
          <button @click="$emit('cancelEditPart')" class="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600 text-sm">Cancel</button>
        </div>
      </template>
      <template v-else>
        <h2 class="text-lg font-semibold">{{ part.name }}</h2>
        <div class="flex gap-2">
          <button @click="$emit('startEditPart', part)" class="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600 text-xs">Edit</button>
          <button @click="$emit('deletePart', part.id)" class="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700 text-xs">Delete</button>
        </div>
      </template>
    </div>

    <ul class="grid gap-3">
      <li v-for="opt in part.part_options || []" :key="opt.id" class="p-3 rounded border shadow-sm bg-gray-50">
        <template v-if="editingOption[opt.id]">
          <form @submit.prevent="$emit('saveOption', opt.id)" class="grid grid-cols-1 md:grid-cols-5 gap-2 items-center text-sm">
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
              <button type="button" @click="$emit('cancelEditOption', opt.id)" class="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600">Cancel</button>
            </div>
          </form>
        </template>

        <template v-else>
          <div class="flex justify-between items-start">
            <div>
              <p class="font-medium text-gray-800">
                {{ opt.name }} — €{{ opt.base_price }}
                <span class="ml-2 text-xs uppercase" :class="opt.stock_status === 'available' ? 'text-green-600' : 'text-gray-400'">({{ opt.stock_status }})</span>
                <span v-if="opt.stock_count >= 0" class="ml-2 text-xs text-gray-700">• {{ opt.stock_count }} in stock</span>
                <span v-if="opt.stock_count < 3" class="ml-2 text-xs text-red-600 font-semibold">🔴 Low stock</span>
              </p>
              <router-link
                :to="{ path: `/part/${part.id}/option/${opt.id}/conditional-prices`, query: { optionName: opt.name, productId } }"
                class="text-indigo-600 hover:underline text-xs"
              >
                Set Conditional Prices
              </router-link>
            </div>
            <div class="flex gap-2">
              <button @click="$emit('startEditOption', opt)" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600 text-xs">Edit</button>
              <button @click="$emit('deleteOption', opt.id)" class="bg-red-600 text-white px-2 py-1 rounded hover:bg-red-700 text-xs">Delete</button>
            </div>
          </div>
        </template>
      </li>
    </ul>

    <div class="mt-4 p-3 border border-gray-200 rounded bg-gray-50">
      <h3 class="text-sm font-semibold mb-2">Add Option</h3>
      <form @submit.prevent="$emit('createOption', part.id, newOptions)" class="grid grid-cols-1 md:grid-cols-4 gap-4 text-sm">
        <input v-model="newOptions.name" placeholder="Option Name" class="input" required />
        <input type="number" v-model="newOptions.base_price" placeholder="Base Price" class="input" required />
        <input type="number" v-model="newOptions.stock_count" placeholder="Stock Count" min="0" class="input" required />
        <select v-model="newOptions.stock_status" class="input">
          <option value="available">Available</option>
          <option value="out_of_stock">Out of Stock</option>
        </select>
        <button
          type="submit"
          class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 col-span-1 md:col-span-4"
        >
          Add Option
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
const props = defineProps([
  'part',
  'editingPart',
  'editedPartName',
  'editingOption',
  'newOptions',
  'productId'
])
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

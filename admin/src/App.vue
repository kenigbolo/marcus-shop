<template>
  <div class="flex min-h-screen bg-gray-100">
    <Sidebar />
    <main class="flex-1 p-6">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import Sidebar from './components/Sidebar.vue'
</script>

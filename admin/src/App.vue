<template>
  <div class="flex min-h-screen bg-gray-100">
    <Sidebar />
    <main class="flex-1 p-6">
      <router-view />
    </main>
    <Toaster position="top-right" />
  </div>
</template>

<script setup>
import Sidebar from './components/Sidebar.vue'
import { Toaster } from 'vue-sonner'
</script>

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: true,        // 👈 bind to 0.0.0.0 (inside Docker)
    port: 4173,        // 👈 consistent port mapping
    strictPort: true,  // 👈 fail if port 4173 is taken
  },
})


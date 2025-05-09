import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [vue(), tailwindcss()],
  server: {
    host: true,        // 👈 bind to 0.0.0.0 (inside Docker)
    port: 4173,        // 👈 consistent port mapping
    strictPort: true,  // 👈 fail if port 4173 is taken
  },
  test: {
    globals: true,
    environment: 'jsdom',
    coverage: {
      reporter: ['text', 'json', 'html'],
      statements: 80,
      branches: 70,
      functions: 80,
      lines: 80
    }
  }
})


import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { Toaster } from 'vue-sonner'
import './style.css'


const app = createApp(App)
app.use(router)
app.mount('#app')

app.component('Toaster', Toaster)

import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../pages/Dashboard.vue'
import Products from '../pages/Products.vue'
import ProductParts from '../pages/ProductParts.vue'

const routes = [
  { path: '/', component: Dashboard },
  { path: '/products', component: Products },
  { path: '/products/:id/parts', component: ProductParts }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router

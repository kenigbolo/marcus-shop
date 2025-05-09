import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../pages/Dashboard.vue'
import Products from '../pages/Products.vue'
import ProductParts from '../pages/ProductParts.vue'
import ConditionalPrices from '../pages/ConditionalPrices.vue'
import OptionConstraints from '../pages/OptionConstraints.vue'

const routes = [
  { path: '/', component: Dashboard },
  { path: '/products', component: Products },
  { path: '/products/:id/parts', component: ProductParts },
  { path: '/part/:part_id/option/:option_id/conditional-prices', component: ConditionalPrices },
  { path: '/part/:part_id/option/:option_id/constraints', component: OptionConstraints }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router

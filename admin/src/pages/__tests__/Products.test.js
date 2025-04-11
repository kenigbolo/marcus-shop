// import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import Products from '../Products.vue'
import { createRouter, createMemoryHistory } from 'vue-router'

// ✅ Mock axios.create
vi.mock('axios', () => {
  const mockAxios = {
    get: vi.fn(),
    post: vi.fn(),
    put: vi.fn(),
    delete: vi.fn()
  }

  return {
    default: {
      create: () => mockAxios
    }
  }
})

import axios from 'axios'
const mockApi = axios.create()

const router = createRouter({
  history: createMemoryHistory(),
  routes: [
    { path: '/products', component: Products }
  ]
})

describe('Products.vue', () => {
  beforeEach(() => {
    vi.resetAllMocks()
  })

  it('renders the heading', async () => {
    const wrapper = mount(Products, {
      global: {
        plugins: [router]
      }
    })
    await router.push('/products')
    await router.isReady()

    expect(wrapper.text()).toContain('Products')
  })

  it('loads product list from mock API', async () => {
    mockApi.get.mockResolvedValue({
      data: [
        { id: 1, name: 'Bike', category: 'bicycle', is_active: true }
      ]
    })

    const wrapper = mount(Products, {
      global: {
        plugins: [router]
      }
    })

    await router.push('/products')
    await router.isReady()
    await new Promise(resolve => setTimeout(resolve, 10)) // simulate async DOM update

    expect(wrapper.text()).toContain('Bike')
  })

  it('displays fallback UI on API failure', async () => {
    mockApi.get.mockRejectedValue(new Error('API error'))

    const wrapper = mount(Products, {
      global: {
        plugins: [router]
      }
    })

    await router.push('/products')
    await router.isReady()
    await new Promise(resolve => setTimeout(resolve, 10))

    expect(wrapper.text()).toContain('Failed to load products')
  })
})

import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import ProductParts from '../ProductParts.vue'
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
    { path: '/products/:id/parts', component: ProductParts }
  ]
})

describe('ProductParts.vue', () => {
  beforeEach(() => {
    vi.resetAllMocks()
  })

  it('renders parts and options for a product', async () => {
    mockApi.get.mockResolvedValue({
      data: {
        id: 1,
        name: 'Bike',
        parts: [
          {
            id: 11,
            name: 'Frame',
            part_options: [
              {
                id: 101,
                name: 'Full-suspension',
                base_price: 130,
                stock_status: 'available'
              }
            ]
          }
        ]
      }
    })

    const wrapper = mount(ProductParts, {
      global: {
        plugins: [router]
      }
    })

    await router.push('/products/1/parts')
    await router.isReady()
    await new Promise(resolve => setTimeout(resolve, 10)) // allow async DOM update

    expect(wrapper.text()).toContain('Frame')
    expect(wrapper.text()).toContain('Full-suspension')
  })

  it('submits a new part', async () => {
    mockApi.get.mockResolvedValueOnce({
      data: { id: 1, name: 'Bike', parts: [] }
    })
    mockApi.post.mockResolvedValueOnce({ data: { id: 2, name: 'Chain' } })

    const wrapper = mount(ProductParts, {
      global: {
        plugins: [router]
      }
    })

    await router.push('/products/1/parts')
    await router.isReady()
    await new Promise(resolve => setTimeout(resolve, 10))

    const input = wrapper.find('input[placeholder="e.g., Frame, Wheels, Chain"]')
    await input.setValue('Chain')
    await wrapper.find('form').trigger('submit.prevent')

    expect(mockApi.post).toHaveBeenCalledWith('/products/1/parts', {
      part: { name: 'Chain' }
    })
  })
})

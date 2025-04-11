import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import ProductParts from '../ProductParts.vue'
import axios from 'axios'
import { createRouter, createMemoryHistory } from 'vue-router'

vi.mock('axios')

const router = createRouter({
  history: createMemoryHistory(),
  routes: [{ path: '/products/:id/parts', component: ProductParts }]
})

describe('ProductParts.vue', () => {
  beforeEach(() => {
    vi.resetAllMocks()
  })

  it('renders parts and options correctly', async () => {
    axios.create().get.mockResolvedValue({
      data: {
        id: 1,
        name: 'Bike',
        parts: [
          {
            id: 11,
            name: 'Frame',
            part_options: [
              { id: 101, name: 'Matte', base_price: 50, stock_status: 'available' }
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

    expect(wrapper.html()).toContain('Frame')
    expect(wrapper.html()).toContain('Matte')
  })

  it('submits new part', async () => {
    axios.create().get.mockResolvedValue({ data: { id: 1, name: 'Bike', parts: [] } })
    axios.create().post.mockResolvedValue({ data: { id: 2, name: 'Chain' } })

    const wrapper = mount(ProductParts, {
      global: {
        plugins: [router]
      }
    })

    await router.push('/products/1/parts')
    await router.isReady()

    const input = wrapper.find('input[placeholder="e.g., Frame, Wheels, Chain"]')
    await input.setValue('Chain')
    await wrapper.find('form').trigger('submit.prevent')

    expect(axios.create().post).toHaveBeenCalled()
  })
})

import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import OptionConstraints from '../OptionConstraints.vue'
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
    { path: '/part/:option_id/constraints', component: OptionConstraints }
  ]
})

describe('OptionConstraints.vue', () => {
  beforeEach(() => {
    vi.resetAllMocks()
  })

  it('renders constraint list with names', async () => {
    mockApi.get
      .mockResolvedValueOnce({
        data: {
          id: 1,
          parts: [
            {
              id: 101,
              name: 'Frame',
              part_options: [
                { id: 1001, name: 'Full Suspension' },
                { id: 1002, name: 'Diamond' }
              ]
            }
          ]
        }
      })
      .mockResolvedValueOnce({
        data: [
          {
            id: 'abc123',
            target_option_id: 1002,
            constraint_type: 'requires'
          }
        ]
      })

    const wrapper = mount(OptionConstraints, {
      global: {
        plugins: [router]
      }
    })

    await router.push('/part/1001/constraints')
    await router.isReady()
    await new Promise(resolve => setTimeout(resolve, 10))

    expect(wrapper.text()).toContain('REQUIRES')
    expect(wrapper.text()).toContain('Diamond')
  })

  it('submits a new constraint', async () => {
    mockApi.get
      .mockResolvedValueOnce({
        data: {
          id: 1,
          parts: [
            {
              id: 101,
              name: 'Frame',
              part_options: [
                { id: 1001, name: 'Full Suspension' },
                { id: 1002, name: 'Diamond' }
              ]
            },
            {
              id: 102,
              name: 'Wheels',
              part_options: [
                { id: 2001, name: 'Mountain' },
                { id: 2002, name: 'Road' }
              ]
            }
          ]
        }
      })
      .mockResolvedValueOnce({ data: [] }) // No existing constraints

    mockApi.post.mockResolvedValueOnce({
      data: {
        id: 'new123',
        source_option_id: 1001,
        target_option_id: 2002,
        constraint_type: 'prohibits'
      }
    })

    const wrapper = mount(OptionConstraints, {
      global: {
        plugins: [router]
      }
    })

    await router.push('/part/1001/constraints?optionName=Full%20Suspension&productId=1')
    await router.isReady()
    await new Promise(resolve => setTimeout(resolve, 10))

    await wrapper.find('select').setValue('102') // Select part
    await new Promise(resolve => setTimeout(resolve)) // allow DOM to populate second dropdown

    const optionSelects = wrapper.findAll('select')
    await optionSelects[1].setValue('2002') // Select "Road"
    await optionSelects[2].setValue('prohibits')

    await wrapper.find('form').trigger('submit.prevent')

    expect(mockApi.post).toHaveBeenCalledWith(
      'http://localhost:3000/api/part_options/1001/constraints',
      {
        option_constraint: {
          source_option_id: '1001',
          target_option_id: 2002,
          constraint_type: 'prohibits'
        }
      }
    )
  })
})

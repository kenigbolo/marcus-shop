import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { MemoryRouter, Routes, Route } from 'react-router-dom'
import { server } from '../../mocks/server'
import { http, HttpResponse } from 'msw'

// ✅ Mock outlet context to provide cartId
// Mocks must go BEFORE component import
vi.mock('react-router-dom', async () => {
  const actual = await vi.importActual('react-router-dom')
  return {
    ...actual,
    useOutletContext: () => ({ cartId: 'test-cart' })
  }
})

vi.mock('../../context/CartContext', () => ({
  useCart: () => ({
    refreshCartCount: vi.fn()
  })
}))

import CartPage from '../CartPage'


import { toast } from 'react-hot-toast'

vi.mock('react-hot-toast', () => {
  const success = vi.fn()
  const error = vi.fn()
  const mockToast = { success, error }

  return {
    __esModule: true,
    default: mockToast,
    toast: mockToast
  }
})

const renderCart = () => {
  return render(
    <MemoryRouter initialEntries={['/cart']}>
      <Routes>
        <Route path="/cart" element={<CartPage />} />
      </Routes>
    </MemoryRouter>
  )
}

describe('CartPage', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('renders cart item with name and options', async () => {
    renderCart()

    expect(await screen.findByText(/custom bike/i)).toBeInTheDocument()
    expect(screen.getByText(/diamond/i)).toBeInTheDocument()
    expect(screen.getByText(/frame/i)).toBeInTheDocument()
  })

  it('calculates and displays subtotal correctly', async () => {
    renderCart()

    expect(await screen.findByText(/subtotal/i)).toBeInTheDocument()
    expect(screen.getByText(/200/i)).toBeInTheDocument() // 100 × 2
  })

  it('renders empty message when cart is empty', async () => {
    server.use(
      http.get('/api/carts/:id', () =>
        HttpResponse.json({ id: 'test-cart', user_id: 'u123', cart_items: [] })
      )
    )

    renderCart()
    expect(await screen.findByText(/your cart is empty/i)).toBeInTheDocument()
  })

  it('shows error toast if remove fails', async () => {
    server.use(
      http.delete('/api/carts/:cartId/items/:itemId', () =>
        HttpResponse.error()
      )
    )

    renderCart()

    const removeBtn = await screen.findByRole('button', { name: /remove/i })
    fireEvent.click(removeBtn)

    await waitFor(() => {
      expect(toast.error).toHaveBeenCalledWith(expect.stringContaining('Failed'))
    })
  })
})

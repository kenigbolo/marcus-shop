import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import { MemoryRouter, Routes, Route } from 'react-router-dom'
import { server } from '../../mocks/server'
import { http, HttpResponse } from 'msw'

// ✅ Mock OutletContext and react-router-dom first
vi.mock('react-router-dom', async () => {
  const actual = await vi.importActual('react-router-dom')
  return {
    ...actual,
    useOutletContext: () => ({ cartId: 'test-cart', refreshCartCount: vi.fn() })
  }
})

// ✅ Mock useCart context
vi.mock('../../context/CartContext', () => ({
  useCart: () => ({
    refreshCartCount: vi.fn()
  })
}))

// ✅ Mock toast
vi.mock('react-hot-toast', () => {
  const mockToast = {
    success: vi.fn(),
    error: vi.fn()
  }
  return {
    __esModule: true,
    default: mockToast,
    toast: mockToast
  }
})


import ProductDetail from '../ProductDetail'
import { toast } from 'react-hot-toast'

const renderWithRouter = (id = '1') => {
  return render(
    <MemoryRouter initialEntries={[`/products/${id}`]}>
      <Routes>
        <Route path="/products/:id" element={<ProductDetail />} />
      </Routes>
    </MemoryRouter>
  )
}

describe('ProductDetail', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('renders product name and description', async () => {
    renderWithRouter()

    expect(await screen.findByText(/custom bike/i)).toBeInTheDocument()
    expect(screen.getByText(/a customizable ride/i)).toBeInTheDocument()
  })

  it('renders parts and options', async () => {
    renderWithRouter()

    expect(await screen.findByText('Frame')).toBeInTheDocument()
    expect(screen.getByText(/Diamond/)).toBeInTheDocument()
    expect(screen.getByText(/Step-through/)).toBeInTheDocument()
  })

  it('updates price when selecting options', async () => {
    renderWithRouter()

    const option = await screen.findByText(/Diamond/)
    fireEvent.click(option)

    expect(await screen.findByText(/Total Price: €100/)).toBeInTheDocument()
  })

  it('submits add to cart and shows toast', async () => {
    renderWithRouter()

    fireEvent.click(await screen.findByText(/Diamond/))
    const addButton = screen.getByRole('button', { name: /add to cart/i })
    fireEvent.click(addButton)

    await new Promise(resolve => setTimeout(resolve, 300))

    expect(toast.success).toHaveBeenCalledWith(expect.stringContaining('Item added'))
  })
})

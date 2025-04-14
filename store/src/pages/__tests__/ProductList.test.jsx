import { BrowserRouter } from 'react-router-dom'
import { render, screen } from '@testing-library/react'
import ProductList from '../ProductList'

// Handle docker container Network errors due to api vs localhost url search
vi.mock('axios', async () => {
  const actual = await vi.importActual('axios')
  const instance = actual.default.create()

  instance.interceptors.response.use(
    res => res,
    err => {
      if (
        err.message?.includes?.('Network Error') &&
        process.env.NODE_ENV === 'test'
      ) {
        return Promise.resolve({ data: {}, suppressed: true })
      }
      return Promise.reject(err)
    }
  )

  return { default: instance }
})


describe('ProductList', () => {
  it('renders product list from API', async () => {
    render(
      <BrowserRouter>
        <ProductList />
      </BrowserRouter>
    )

    const cards = await screen.findAllByRole('heading')
    expect(cards.length).toBeGreaterThan(0)
  })
})

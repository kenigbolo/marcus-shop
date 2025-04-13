import { BrowserRouter } from 'react-router-dom'
import { render, screen } from '@testing-library/react'
import ProductList from '../ProductList'

describe('ProductList', () => {
  it('renders product list from API', async () => {
    render(
      <BrowserRouter>
        <ProductList />
      </BrowserRouter>
    )
    const cards = await screen.findAllByRole('heading', { level: 2 })
    expect(cards.length).toBeGreaterThan(0)
  })
})

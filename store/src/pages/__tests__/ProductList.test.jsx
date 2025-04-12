import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import ProductList from '../ProductList'

describe('ProductList', () => {
  it('renders the Products heading', () => {
    render(<ProductList />)
    expect(screen.getByRole('heading', { name: /products/i })).toBeInTheDocument()
  })
})

import { createContext, useContext, useState, useEffect } from 'react'
import api from '../api'

const CartContext = createContext()

export const CartProvider = ({ cartId, children }) => {
  const [itemCount, setItemCount] = useState(0)

  const refreshCartCount = () => {
    if (!cartId) return
    api.get(`/carts/${cartId}`)
    .then(res => {
      const count = res.data.cart_items?.reduce((sum, item) => sum + (item.quantity || 1), 0) || 0
      setItemCount(count)
    })
    .catch(() => setItemCount(0))
  }

  useEffect(() => {
    refreshCartCount()
  }, [cartId])

  return (
    <CartContext.Provider value={{ itemCount, refreshCartCount }}>
      {children}
    </CartContext.Provider>
  )
}

export const useCart = () => useContext(CartContext)

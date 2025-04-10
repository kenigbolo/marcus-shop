import { createContext, useContext, useState, useEffect } from 'react'
import axios from 'axios'

const CartContext = createContext()

export const CartProvider = ({ cartId, children }) => {
  const [itemCount, setItemCount] = useState(0)

  const refreshCartCount = () => {
    if (!cartId) return
    axios.get(`${import.meta.env.VITE_API_BASE_URL}/carts/${cartId}`, {
      headers: { 'X-User-ID': import.meta.env.VITE_USER_ID }
    })
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

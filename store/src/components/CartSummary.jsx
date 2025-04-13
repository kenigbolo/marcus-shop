import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'
import { useCart } from '../context/CartContext'
import { TrashIcon } from '@heroicons/react/24/outline'

export default function CartSummary({ cartId }) {
  const [cart, setCart] = useState(null)
  const [loading, setLoading] = useState(true)
  const { refreshCartCount } = useCart()

  const loadCart = () => {
    setLoading(true)
    axios.get(`${import.meta.env.VITE_API_BASE_URL}/carts/${cartId}`, {
      headers: { 'X-User-ID': import.meta.env.VITE_USER_ID }
    })
    .then(res => setCart(res.data))
    .catch(() => toast.error("Failed to load cart"))
    .finally(() => setLoading(false))
  }

  useEffect(() => {
    loadCart()
  }, [cartId])

  const handleRemove = async (itemId) => {
    try {
      await axios.delete(`${import.meta.env.VITE_API_BASE_URL}/carts/${cartId}/items/${itemId}`, {
        headers: { 'X-User-ID': import.meta.env.VITE_USER_ID }
      })
      toast.success("Item removed from cart")
      refreshCartCount()
      loadCart()
    } catch (err) {
      toast.error("Failed to remove item")
    }
  }

  if (loading) return <p className="text-sm text-gray-400">Loading cart...</p>
  if (!cart || !cart.cart_items?.length) return <p className="text-sm text-gray-500 italic">Your cart is empty.</p>

  const subtotal = (cart.cart_items || []).reduce((total, item) => {
    const itemQuantity = Number(item.quantity || 1)
  
    const itemTotal = (item.cart_item_options || []).reduce((sum, opt) => {
      const price = Number(opt?.price_applied || 0)
      return sum + price
    }, 0)
    return total + itemTotal * itemQuantity
  }, 0)

  return (
    <div className="p-5 bg-gray-50 border border-gray-200 rounded-lg shadow">
      <h3 className="text-lg font-semibold mb-4 text-indigo-700">Your Cart</h3>

      <ul className="space-y-4">
        {cart.cart_items.map(item => (
          <li key={item.id} className="text-sm border-b pb-2">
            <div className="flex justify-between items-center mb-1">
              <p className="font-medium text-gray-800">
                {item.quantity} × {item.product?.name}
              </p>
              <button aria-label="Remove Item" onClick={() => handleRemove(item.id)} className="text-red-600 hover:text-red-800">
                <TrashIcon className="h-4 w-4 inline" />
              </button>
            </div>
            <ul className="ml-4 list-disc text-gray-700">
              {(item.cart_item_options || []).map(opt => (
                <li key={opt.id}>
                  {opt.part_option?.part?.name}: {opt.part_option?.name} — €{opt.price_applied}
                </li>
              ))}
            </ul>
          </li>
        ))}
      </ul>

      <div className="mt-4 text-right font-semibold text-gray-900">
        Subtotal: €{subtotal.toFixed(2)}
      </div>
    </div>
  )
}

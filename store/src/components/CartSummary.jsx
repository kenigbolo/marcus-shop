import { useEffect, useState } from 'react'
import axios from 'axios'
import toast from 'react-hot-toast'

export default function CartSummary({ cartId }) {
  const [cart, setCart] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    axios.get(`${import.meta.env.VITE_API_BASE_URL}/carts/${cartId}`, {
      headers: { 'X-User-ID': import.meta.env.VITE_USER_ID }
    })
    .then(res => setCart(res.data))
    .catch(() => toast.error("Failed to load cart"))
    .finally(() => setLoading(false))
  }, [cartId])

  if (loading) return <p className="text-sm text-gray-400">Loading cart...</p>
  if (!cart || !cart.cart_items?.length) return <p className="text-sm text-gray-500 italic">Your cart is empty.</p>

  const subtotal = cart.cart_items.reduce((total, item) => {
    const itemTotal = (item.cart_item_options || []).reduce(
      (sum, opt) => sum + (opt.price_applied || 0),
      0
    )
    return total + itemTotal * (item.quantity || 1)
  }, 0)

  return (
    <div className="mt-10 p-5 bg-gray-50 border border-gray-200 rounded-lg shadow">
      <h3 className="text-lg font-semibold mb-4 text-indigo-700">Your Cart</h3>

      <ul className="space-y-4">
        {cart.cart_items.map(item => (
          <li key={item.id} className="text-sm">
            <p className="font-medium text-gray-800">{item.quantity} × {item.product_id}</p>
            <ul className="ml-4 list-disc text-gray-700">
            {(item.cart_item_options || []).map(opt => (
              <li key={opt.id}>{opt.part_option_id} — €{opt.price_applied}</li>
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

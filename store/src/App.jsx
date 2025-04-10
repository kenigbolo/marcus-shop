import { useEffect, useState } from 'react'
import { Outlet, Link } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
import { ShoppingCartIcon } from '@heroicons/react/24/outline'
import axios from 'axios'
import { CartProvider, useCart } from './context/CartContext'

function AppLayout({ cartId }) {
  const { itemCount } = useCart()

  return (
    <div className="p-4 max-w-6xl mx-auto">
      <header className="flex items-center justify-between mb-6">
        <h1 className="text-3xl font-bold text-indigo-700">Marcus's Custom Bikes</h1>
        <Link to="/cart" className="relative text-gray-600 hover:text-indigo-700">
          <ShoppingCartIcon className="h-6 w-6" />
          {itemCount > 0 && (
            <span className="absolute -top-2 -right-2 text-xs bg-red-600 text-white rounded-full px-2 py-0.5">
              {itemCount}
            </span>
          )}
        </Link>
      </header>

      <Outlet context={{ cartId }} />
      <Toaster position="top-center" reverseOrder={false} />
    </div>
  )
}

export default function App() {
  const [cartId, setCartId] = useState(null)

  useEffect(() => {
    axios.post(`${import.meta.env.VITE_API_BASE_URL}/carts`, {}, {
      headers: {
        'X-User-ID': import.meta.env.VITE_USER_ID
      }
    })
    .then(res => setCartId(res.data.id))
  }, [])

  if (!cartId) return <div className="p-6 text-center text-gray-500">Loading cart...</div>

  return (
    <CartProvider cartId={cartId}>
      <AppLayout cartId={cartId} />
    </CartProvider>
  )
}

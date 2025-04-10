import { useEffect, useState } from 'react'
import { Outlet, Link } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
import { ShoppingCartIcon } from '@heroicons/react/24/outline'
import axios from 'axios'

export default function App() {
  const [cartId, setCartId] = useState(null)
  // Create a new cart on mount (temporary for now), should be changed to a more robust solution
  useEffect(() => {
    axios.post(`${import.meta.env.VITE_API_BASE_URL}/carts`, {}, {
      headers: {
        'X-User-ID': import.meta.env.VITE_USER_ID
      }
    })
    .then(res => setCartId(res.data.id))
  }, [])

  if (!cartId) return <div>Loading cart...</div>

  return (
    <div className="p-4 max-w-6xl mx-auto">
      <header className="flex items-center justify-between mb-6">
        <h1 className="text-3xl font-bold text-indigo-700">Marcus's Custom Bikes</h1>
        <Link to="/cart" className="text-gray-600 hover:text-indigo-700 relative">
          <ShoppingCartIcon className="h-6 w-6" />
        </Link>
      </header>
      <Outlet context={{ cartId }} />
      <Toaster position="top-center" reverseOrder={false} />
    </div>
  )
}
import { useEffect, useState } from 'react'
import { Outlet } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
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
    <div className="p-6 max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold text-center mb-6">Marcus's Custom Bikes</h1>
      <Outlet context={{ cartId }} />
      <Toaster position="top-right" reverseOrder={false} />
    </div>
  )
}

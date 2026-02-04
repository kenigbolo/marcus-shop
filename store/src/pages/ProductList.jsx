import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'

export default function ProductList() {
  const [products, setProducts] = useState([])

  useEffect(() => {
    function logApiError(err) {
      const details = {
        message: err?.message,
        status: err?.response?.status,
        url: err?.config?.url,
        method: err?.config?.method,
        requestHeaders: err?.config?.headers,
        responseData: err?.response?.data,
        userAgent: (typeof navigator !== 'undefined' && navigator.userAgent) || null,
        page: (typeof window !== 'undefined' && window.location.href) || null
      }
      // Structured log for easier searching in browser/remote logs
      console.error('API Error:', details)
    }

    console.log('API URL:', import.meta.env.VITE_API_BASE_URL)
    console.log('User ID:', import.meta.env.VITE_USER_ID)

    axios.get(`${import.meta.env.VITE_API_BASE_URL}/products`, {
      headers: { 'X-User-ID': import.meta.env.VITE_USER_ID }
    })
      .then(res => {
        console.log('Products loaded:', Array.isArray(res.data) ? res.data.length + ' items' : typeof res.data)
        setProducts(res.data)
      })
      .catch(err => {
        logApiError(err)
        setProducts([])
      })
  }, [])

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Products</h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {products.map(product => (
          <div key={product.id} className="bg-gradient-to-br from-white via-indigo-50 to-indigo-100 border border-indigo-200 p-5 rounded-lg shadow-md hover:shadow-lg transition">
            <h2 className="text-xl font-semibold text-indigo-800">{product.name}</h2>
            <p className="text-sm text-gray-600 mt-2">{product.description}</p>
            <Link to={`/products/${product.id}`} className="inline-block mt-4 px-4 py-2 bg-indigo-600 text-white text-sm rounded hover:bg-indigo-700">
              View Details
            </Link>
          </div>
        ))}
      </div>
    </div>
  )
}


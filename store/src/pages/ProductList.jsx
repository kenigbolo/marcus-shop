import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'

export default function ProductList() {
  const [products, setProducts] = useState([])

  useEffect(() => {
    axios.get(`${import.meta.env.VITE_API_BASE_URL}/products`, {
      headers: {
        'X-User-ID': import.meta.env.VITE_USER_ID
      }
    }).then(res => setProducts(res.data))
  }, [])

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      {products.map(product => (
        <div key={product.id} className="bg-white shadow-md rounded-lg p-5 border border-gray-100">
          <h2 className="text-xl font-bold text-gray-800">{product.name}</h2>
          <p className="text-gray-600 mt-2">{product.description}</p>
          <Link to={`/products/${product.id}`} className="text-indigo-600 font-medium mt-4 inline-block hover:underline">
            View Details →
          </Link>
        </div>
      ))}
    </div>
  )
}

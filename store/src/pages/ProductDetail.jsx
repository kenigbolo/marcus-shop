import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import axios from 'axios'

export default function ProductDetail() {
  const { id } = useParams()
  const [product, setProduct] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    axios.get(`${import.meta.env.VITE_API_BASE_URL}/products/${id}`, {
      headers: {
        'X-User-ID': import.meta.env.VITE_USER_ID
      }
    })
    .then(res => {
      setProduct(res.data)
      setLoading(false)
    })
    .catch(() => setLoading(false))
  }, [id])

  if (loading) return <div>Loading...</div>
  if (!product) return <div>Product not found.</div>
  if (!product.parts) return <div>No parts found for this product.</div>

  return (
    <div className="bg-white rounded shadow-md p-6 border border-gray-100">
      <h2 className="text-2xl font-bold text-gray-900 mb-2">{product.name}</h2>
      <p className="text-gray-600 mb-6">{product.description}</p>

      {product.parts.map(part => (
        <div key={part.id} className="mb-6">
          <h3 className="text-lg font-semibold text-indigo-700">{part.name}</h3>

          {part.part_options?.length ? (
            <ul className="list-disc list-inside text-gray-700 ml-4">
              {part.part_options.map(opt => (
                <li key={opt.id}>
                  {opt.name} <span className="text-sm text-gray-500">€{opt.base_price}</span>
                </li>
              ))}
            </ul>
          ) : (
            <p className="text-sm text-gray-400 italic">No options available</p>
          )}
        </div>
      ))}


      <Link to="/" className="text-indigo-500 hover:underline mt-4 inline-block">← Back to product list</Link>
    </div>
  )
}

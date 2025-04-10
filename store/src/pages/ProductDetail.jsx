import { useEffect, useState } from 'react'
import { useParams, useOutletContext, Link } from 'react-router-dom'
import toast from 'react-hot-toast'
import axios from 'axios'

export default function ProductDetail() {
  const { id } = useParams()
  const { cartId } = useOutletContext()

  const [product, setProduct] = useState(null)
  const [selectedOptions, setSelectedOptions] = useState({})
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    axios.get(`http://localhost:3000/api/products/${id}`, {
      headers: { 'X-User-ID': '3f2c1de2-b879-4f0e-980f-16a48db451c7' }
    }).then(res => setProduct(res.data))
  }, [id])

  const handleSelect = (partId, optionId) => {
    setSelectedOptions(prev => ({ ...prev, [partId]: optionId }))
  }

  const handleAddToCart = async () => {
    if (!product) return
    setSubmitting(true)
    try {
      await axios.post(`http://localhost:3000/api/carts/${cartId}/items`, {
        product_id: product.id,
        quantity: 1,
        selected_option_ids: Object.values(selectedOptions)
      }, {
        headers: { 'X-User-ID': '3f2c1de2-b879-4f0e-980f-16a48db451c7' }
      })
      toast.success("Item added to cart!")
    } catch (err) {
      toast.error("Failed to add to cart")
    } finally {
      setSubmitting(false)
    }
  }

  if (!product) return <div>Loading...</div>

  return (
    <div className="bg-white rounded shadow-md p-6 border border-gray-100">
      <h2 className="text-2xl font-bold mb-2">{product.name}</h2>
      <p className="mb-4 text-gray-600">{product.description}</p>

      {product?.parts?.length ? (
        product.parts.map(part => (
          <div key={part.id} className="mb-6">
            <h3 className="font-semibold">{part.name}</h3>

            {part.part_options?.length ? (
              <div className="mt-2 flex gap-2 flex-wrap">
                {part.part_options.map(opt => (
                  <button
                    key={opt.id}
                    onClick={() => handleSelect(part.id, opt.id)}
                    className={`px-3 py-1 rounded border text-sm ${
                      selectedOptions[part.id] === opt.id
                        ? 'bg-indigo-600 text-white'
                        : 'bg-white border-gray-300 text-gray-700'
                    }`}
                  >
                    {opt.name} (€{opt.base_price})
                  </button>
                ))}
              </div>
            ) : (
              <p className="text-sm text-gray-400 italic">No options available</p>
            )}
          </div>
        ))
      ) : (
        <p className="text-gray-400 italic">No parts available</p>
      )}

      <Link to="/" className="text-indigo-500 hover:underline mt-4 mr-4 inline-block">← Back to product list</Link>


      <button
        disabled={submitting}
        onClick={handleAddToCart}
        className="mt-6 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold px-6 py-2 rounded"
      >
        {submitting ? 'Adding...' : 'Add to Cart'}
      </button>
    </div> 
  )
}

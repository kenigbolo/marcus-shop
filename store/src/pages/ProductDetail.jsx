import { useEffect, useState } from 'react'
import { useParams, useOutletContext, Link } from 'react-router-dom'
import toast from 'react-hot-toast'
import api from '../api'
import { useCart } from '../context/CartContext'
import { AnimatePresence, motion } from 'framer-motion'

export default function ProductDetail() {
  const { id } = useParams()
  const { cartId } = useOutletContext()
  const { refreshCartCount } = useCart()

  const [product, setProduct] = useState(null)
  const [selectedOptions, setSelectedOptions] = useState({})
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    api.get(`/products/${id}`).then(res => setProduct(res.data))
  }, [id])

  const handleSelect = (partId, optionId) => {
    setSelectedOptions(prev => {
      // Deselect if already selected
      if (prev[partId] === optionId) {
        const updated = { ...prev }
        delete updated[partId]
        return updated
      }
      // Otherwise, select it
      return { ...prev, [partId]: optionId }
    })
  }
  

  const calculateTotalPrice = () => {
    if (!product || !product.parts) return 0

    const selectedOptionList = Object.values(selectedOptions)
    let total = 0

    for (const part of product.parts) {
      const selectedId = selectedOptions[part.id]
      const option = part.part_options?.find(opt => opt.id === selectedId)
      if (!option) continue

      const condition = option.conditional_prices?.find(cp =>
        selectedOptionList.includes(cp.context_option_id)
      )

      const finalPrice = Number((condition?.price_override ?? option.base_price) ?? 0)
      total += finalPrice
    }

    return total
  }

  const handleAddToCart = async () => {
    if (!product) return
    setSubmitting(true)
    try {
      await api.post(`/carts/${cartId}/items`, {
        product_id: product.id,
        quantity: 1,
        selected_option_ids: Object.values(selectedOptions)
      })
      toast.success("Item added to cart!")
      refreshCartCount()
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
          <div key={part.id} className="mb-8">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">{part.name}</h3>
            {(part.part_options || [])
              .filter(opt => opt.stock_status === 'available')
              .sort((a, b) => a.base_price - b.base_price)
              .map(opt => (
                <button
                  key={opt.id}
                  onClick={() => handleSelect(part.id, opt.id)}
                  className={`inline-block mr-2 mb-2 px-4 py-2 rounded-full border text-sm font-medium shadow-sm transition ${
                    selectedOptions[part.id] === opt.id
                      ? 'bg-indigo-600 text-white border-indigo-600'
                      : 'bg-white border-gray-300 text-gray-700 hover:border-indigo-400'
                  }`}
                >
                  {opt.name} (€{opt.base_price})
                </button>
              ))}
          </div>
        ))
      ) : (
        <p className="text-gray-400 italic">No parts available</p>
      )}

      <div className="mt-6 p-4 bg-indigo-50 border border-indigo-200 rounded-md">
        <AnimatePresence mode="wait">
          <motion.p
            key={calculateTotalPrice()}
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -8 }}
            transition={{ duration: 0.2 }}
            className="text-lg font-semibold text-indigo-800"
          >
            Total Price: €{calculateTotalPrice().toFixed(2)}
          </motion.p>
        </AnimatePresence>
      </div>

      <div className="mt-6 flex flex-wrap gap-4">
        <Link to="/" className="text-indigo-500 hover:underline inline-block">← Back to product list</Link>
        <button
          disabled={submitting}
          onClick={handleAddToCart}
          className="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold px-6 py-2 rounded"
        >
          {submitting ? 'Adding...' : 'Add to Cart'}
        </button>
      </div>
    </div>
  )
}


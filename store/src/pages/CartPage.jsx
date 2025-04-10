import { useOutletContext, Link } from 'react-router-dom'
import CartSummary from '../components/CartSummary'

export default function CartPage() {
  const { cartId } = useOutletContext()

  return (
    <div className="max-w-3xl mx-auto mt-8">
      <Link to="/" className="text-indigo-500 hover:underline mt-4 mr-4 inline-block">← Back to product list</Link>
      <h2 className="text-2xl font-bold mb-4 text-indigo-700">🛒 Your Cart</h2>
      <CartSummary cartId={cartId} />
    </div>
  )
}

import { Outlet } from 'react-router-dom'

export default function App() {
  return (
    <div className="p-4 max-w-4xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Marcus's Custom Bikes</h1>
      <Outlet />
    </div>
  )
}

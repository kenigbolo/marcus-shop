import { http, HttpResponse } from 'msw'

export const handlers = [
  http.get('http://localhost:3000/api/products/:id', ({ params }) => {
    return HttpResponse.json({
      id: params.id,
      name: 'Custom Bike',
      description: 'A customizable ride',
      parts: [
        {
          id: 'frame',
          name: 'Frame',
          part_options: [
            { id: 'opt1', name: 'Diamond', base_price: 100, stock_status: 'available' },
            { id: 'opt2', name: 'Step-through', base_price: 90, stock_status: 'available' }
          ]
        }
      ]
    })
  }),

  http.post('http://localhost:3000/api/carts/:cartId/items', async ({ request }) => {
    const body = await request.json()
    return HttpResponse.json({ id: 'item123', quantity: 1, ...body })
  }),

  http.get('http://localhost:3000/api/carts/:id', ({ params }) => {
    return HttpResponse.json({
      id: params.id,
      user_id: 'u123',
      cart_items: [
        {
          id: 'item1',
          product_id: 'prod1',
          quantity: 2,
          product: { name: 'Custom Bike' },
          cart_item_options: [
            {
              part_option: {
                name: 'Diamond',
                base_price: 100,
                part: { name: 'Frame' }
              },
              price_applied: 100
            }
          ]
        }
      ]      
    })
  }),

  http.delete('http://localhost:3000/api/carts/:cartId/items/:itemId', () => {
    return HttpResponse.status(204)
  })
]

# 📦 API Routes

| Prefix                | Verb   | URI Pattern                                               | Controller#Action                            |
|----------------------|--------|------------------------------------------------------------|-----------------------------------------------|
| `api_cart_items`     | POST   | `/api/carts/:cart_id/items`                               | `api/cart_items#create`                       |
| `api_cart_item`      | DELETE | `/api/carts/:cart_id/items/:id`                           | `api/cart_items#destroy`                      |
| `api_carts`          | POST   | `/api/carts`                                              | `api/carts#create`                            |
| `api_cart`           | GET    | `/api/carts/:id`                                          | `api/carts#show`                              |
| `api_product_parts`  | GET    | `/api/products/:product_id/parts`                         | `api/parts#index`                             |
|                      | POST   | `/api/products/:product_id/parts`                         | `api/parts#create`                            |
| `api_products`       | GET    | `/api/products`                                           | `api/products#index`                          |
|                      | POST   | `/api/products`                                           | `api/products#create`                         |
| `api_product`        | GET    | `/api/products/:id`                                       | `api/products#show`                           |
|                      | PATCH  | `/api/products/:id`                                       | `api/products#update`                         |
|                      | PUT    | `/api/products/:id`                                       | `api/products#update`                         |
|                      | DELETE | `/api/products/:id`                                       | `api/products#destroy`                        |
| `api_part_part_options` | POST | `/api/parts/:part_id/part_options`                        | `api/part_options#create`                     |
| `api_part`           | PATCH  | `/api/parts/:id`                                          | `api/parts#update`                            |
|                      | PUT    | `/api/parts/:id`                                          | `api/parts#update`                            |
|                      | DELETE | `/api/parts/:id`                                          | `api/parts#destroy`                           |
| `api_part_option`    | PATCH  | `/api/part_options/:id`                                   | `api/part_options#update`                     |
|                      | PUT    | `/api/part_options/:id`                                   | `api/part_options#update`                     |
|                      | DELETE | `/api/part_options/:id`                                   | `api/part_options#destroy`                    |
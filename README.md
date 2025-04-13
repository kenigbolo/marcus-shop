# Marcus Custom Shop — E-commerce Platform

Welcome to Marcus's customizable bicycle shop project! This is a full-stack monorepo for an e-commerce platform that allows users to browse, customize, and purchase bicycles online. It is structured for future expansion into other sports-related items like skis, surfboards, and roller skates.

---

## 🏗️ Project Structure

```
marcus-shop/
├── api/         # Ruby on Rails 8 API (PostgreSQL, UUID-based)
├── store/       # React + Vite + Tailwind customer-facing storefront
├── admin/       # Vue + Vite admin panel (WIP)
├── docker-compose.yml
├── Dockerfile   # Used for Rails API service
└── README.md
```

---

## 🚀 Getting Started

### 🐳 Start All Services with Docker Compose

From the root of the project:

```bash
docker-compose up --build -d
```

### 📍 Access the Applications

| Service       | URL                   |
|---------------|------------------------|
| React Store   | http://localhost:5173  |
| Vue Admin     | http://localhost:4173  |
| Rails API     | http://localhost:3000  |


---

## 🧪 Dev Notes

### ✅ Environment Configuration

Each frontend app (`store/`, `admin/`) uses `.env` files. For the React store:

```env
# store/.env
VITE_API_BASE_URL=http://localhost:3000/api
VITE_USER_ID=3f2c1de2-b879-4f0e-980f-16a48db451c7 (or any valid UUID until authentication is implemented)
```

Make sure to restart the Vite server after changing `.env`:
```bash
npm run dev
```


### 📦 Seed the Backend

You can seed the database from the Rails container:

```bash
docker-compose exec api rails db:drop db:create db:migrate db:seed
```

---

### Run the tests
- For the API
```bash
docker compose exec api bundle exec rspec
```

- For the Store UI
```bash
cd store && npx vitest run
```

- For the Admin Dashboard
```bash
docker compose exec admin npx vitest run
```

## 🧩 Features Implemented

### Rails API
- UUID-based models for products, parts, options, constraints, pricing
- Seeded realistic data with Faker
- API authentication via `X-User-ID` header
- Endpoints:
  - `GET /products`, `GET /products/:id`
  - `POST /carts`, `GET /carts/:id`
  - `POST /carts/:cart_id/items`
  - `DELETE /carts/:cart_id/items/:id`

### React Store
- Product listing with Tailwind styling
- Product customization and part selection
- Live price calculation with conditional pricing
- Add to cart with toast notifications
- Cart badge in header with item count
- Cart page with summary and remove functionality

---

## 📝 To Do

### Backend
- [ ] Enforce constraints (e.g. invalid combinations)
- [x] Filter out-of-stock options
- [ ] Support quantity update and checkout

### Storefront
- [ ] Persist cart with localStorage
- [x] Show real product/option names in cart
- [ ] Edit quantity in cart page
- [ ] Checkout flow

### Admin (Vue)
- [x] Product CRUD
- [x] Manage part options, constraints, pricing
- [x] Toggle stock status
- [ ] Admin routing and access control

---

## 🤝 Contributions

Built by [Stephen](https://github.com/kenigbolo) and powered by Docker, Rails 8, React, Vue, and Tailwind CSS.

Feel free to fork and expand this into a real-world shop!


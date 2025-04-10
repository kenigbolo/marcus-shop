# ✅ Marcus Shop Project — Task Checklist

## 📦 Backend (Rails API)

### 🔹 Functional Tasks
- [x] Product listing (`GET /products`)
- [x] Product details (`GET /products/:id`)
- [x] Create cart (`POST /carts`)
- [x] View cart (`GET /carts/:id`)
- [x] Add cart item (`POST /carts/:cart_id/items`)
- [x] Remove cart item (`DELETE /carts/:cart_id/items/:id`)

### 🔹 Enhancements
- [ ] Validate `OptionConstraint` rules on cart item creation
- [ ] Apply `stock_status` availability filtering on option selectors
- [ ] Support `PATCH /cart_items/:id` to update quantity
- [ ] Add endpoint: `GET /products/:id/price-preview` (optional)
- [ ] Add real `User` model and auth association (optional)
- [ ] Improve cart serializers to return names instead of UUIDs

---

## 🎨 Storefront (React + Vite)

### 🔹 UI & UX Features
- [x] Product list (with styles)
- [x] Product customization screen (selector UI + POST to cart)
- [x] Cart summary page (`/cart`)
- [x] Live cart badge with item count
- [x] Remove item from cart (via 🗑️ icon)
- [x] Toast notifications

### 🔹 Improvements
- [x] Display product & option **names** (instead of UUIDs) in cart
- [x] Show **live price total** while customizing a product
- [ ] Persist cart ID across sessions (e.g. `localStorage`)
- [ ] Support **editing quantity** in cart
- [ ] Add **checkout** page (can be a simple summary for now)
- [ ] Add **error boundaries** and loading skeletons
- [ ] Extract `axios` setup to a shared API helper file

---

## 🧑‍💼 Admin Panel (Vue + Vite) — *Not Started Yet*

### 🔹 Base Setup
- [ ] Initialize Vue project (`/admin`)
- [ ] Configure router, layout, and axios with `.env`

### 🔹 Feature Pages
- [ ] Product management (CRUD)
- [ ] Manage parts and part options
- [ ] Set conditional prices and constraints
- [ ] Mark part options in/out of stock
- [ ] View and debug carts (optional)

### 🔹 Admin Experience
- [ ] Add `X-Admin-ID` header for API calls
- [ ] Add login page (optional, mock auth)

---

## 🛠️ Tooling & Dev Workflow

### 🔹 Essentials
- [x] `.env` support for config (Vite + Rails)
- [x] Docker Compose setup
- [x] Tailwind CSS with custom styles
- [x] Toast notifications

### 🔹 Improvements
- [x] Update readme with setup instructions
- [ ] Auto-reload Rails in Docker with `bin/dev` or `guard`
- [ ] Basic test coverage (RSpec, React Testing Library)

---
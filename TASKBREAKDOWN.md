## ✅ Completed Features

- **Products API**
  - CRUD (create, read, update, delete)
  - Includes nested parts and part options
- **Parts and PartOptions API**
  - CRUD for both entities
  - Validation of attributes (e.g., required fields, enum values)
- **Carts and CartItems API**
  - Create and retrieve cart
  - Add and remove cart items
  - Apply conditional prices based on selected options
- **Conditional Prices**
  - Define price overrides based on context option
  - Prevent duplicates/conflicts (uniqueness enforced)
- **Storefront**
  - Product listing and detail page
  - Add to cart workflow
  - Cart summary
- **Test Coverage**
  - Full request specs for Rails API
  - Frontend integration tests for store app
- **User context via headers**
  - `X-User-ID` and `X-Admin-ID` handled in `ApplicationController`
- **Admin App**
  - Configuration and test-ready setup for product/option management
  - Admin dashboard UI
  - Inventory and stock handling
- **🧱 Infrastructure & Dev Setup**
  - Database seeding with complex examples
  - Dev notes on multi-app setup (store, admin, API)
- **🔶 Option Constraints**
  - Model & relationships
  - API support for create, read, update, delete
  - Validation for circular and self-referencing constraints
---

## 💠 Still To Be Implemented

### 🔶 Option Constraints (New Feature)
- UI experience TBD

### 🧪 Additional Testing
- Cart behavior when invalid option combinations are selected
- Frontend validation for constraints (disable/enable options)

### 🧱 Infrastructure & Dev Setup
- Linting, formatting, CI integration

### 🧰 Future (Stretch Goals)
- User accounts & authentication
- Persistent cart behavior across sessions
- Checkout / payments


## 📦 Backend (Rails API)

### 🔹 Functional Tasks
- [x] Product listing (`GET /products`)
- [x] Product details (`GET /products/:id`)
- [x] Create cart (`POST /carts`)
- [x] View cart (`GET /carts/:id`)
- [x] Add cart item (`POST /carts/:cart_id/items`)
- [x] Remove cart item (`DELETE /carts/:cart_id/items/:id`)
- [x] Update cart item quantity (`PATCH /carts/:cart_id/items/:id`)

### 🔹 Enhancements
- [x] Validate `OptionConstraint` rules on cart item creation
- [ ] Apply `stock_status` availability filtering on option selectors
- [x] Support `PATCH /cart_items/:id` to update quantity
- [ ] Add endpoint: `GET /products/:id/price-preview` (optional)
- [ ] Add real `User` model and auth association (optional)
- [x] Improve cart serializers to return names instead of UUIDs

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
- [x] Support **editing quantity** in cart
- [ ] Add **checkout** page (can be a simple summary for now)
- [ ] Add **error boundaries** and loading skeletons
- [x] Extract `axios` setup to a shared API helper file

---

## 🧑‍💼 Admin Panel (Vue + Vite) — *Not Started Yet*

### 🔹 Base Setup
- [x] Initialize Vue project (`/admin`)
- [x] Configure router, layout, and axios with `.env`

### 🔹 Feature Pages
- [x] Product management (CRUD)
- [x] Manage parts and part options
- [x] Set conditional prices and constraints
- [x] Mark part options in/out of stock
- [ ] View and debug carts (optional)

### 🔹 Admin Experience
- [x] Add `X-Admin-ID` header for API calls
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
- [x] Auto-reload Rails in Docker with `bin/dev` or `guard`
- [x] Basic test coverage (RSpec, React Testing Library)

---
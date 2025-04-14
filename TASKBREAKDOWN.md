# ✅ Marcus Shop Project — Task Checklist

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
- **Storefront**
  - Product listing and detail page
  - Add to cart workflow
  - Cart summary
- **Admin App**
  - Admin UI for managing products, parts, and options
  - Includes form validation and conditional logic
  - Integrated with Rails API
- **Test Coverage**
  - Full request specs for Rails API
  - Frontend integration tests for store and admin apps
- **User context via headers**
  - `X-User-ID` and `X-Admin-ID` handled in `ApplicationController`

---

## 💠 Still To Be Implemented

### 🔶 Conditional Prices (Core Logic Refinement)
- Persist and retrieve conditional prices for part options
- Extend JSON response for selected cart items to reflect applied conditional price context

### 🔶 Option Constraints (New Feature)
- Add support for defining constraints between incompatible or required combinations of options
- Ensure validation logic is applied when adding a product with selected options to cart
- UI-level feedback or disabling based on incompatible options

### 🧪 Additional Testing
- Edge case testing: empty carts, disabled products, out-of-stock options
- Performance checks on complex cart assemblies
- JS unit tests for price calculation based on constraints and conditionals

### 🧱 Infrastructure & Dev Setup
- Add documentation for setting up environment variables
- Add optional support for seeding test data
- Auto-restart containers or hot reload instructions for store/admin apps

---

## 🧰 Future (Stretch Goals)
- Admin dashboard for managing products, parts, and options
- Authentication and permissions (User vs Admin scope)
- Cart persistence and session recovery
- Order checkout flow (conversion of cart into order)
- Inventory tracking and low-stock notifications


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
- [ ] Support **editing quantity** in cart
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
- [ ] Set conditional prices and constraints
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
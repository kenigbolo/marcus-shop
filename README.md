# 🛍 Marcus Shop Monorepo

This monorepo powers an e-commerce platform designed to allow a shop owner (Marcus) to sell customizable bicycles online. It includes:

- 🏬 **Storefront** (React) – A customer-facing application where products can be browsed and customized.
- 🎛 **Admin Panel** (Vue) – A management interface to configure products and their parts/options.
- ⚙️ **API** (Rails) – A JSON API powering the frontends.

---

## 📁 Folder Structure

```
marcus-shop/
├── store/        # React (Vite) storefront
├── admin/        # Vue (Vite) admin UI
├── api/          # Rails 8 API backend
└── docker/       # Compose & Docker files
```

---

## 🔧 Requirements

Before running the application, ensure the following are installed:

- **Docker** (>= 20.x)
- **Docker Compose** (>= 2.x)
- **Ruby** 3.2.2 (if running the Rails API without Docker)
- **Rails** 8.0.x
- **PostgreSQL** >= 14 (only if not using Docker)
- **Node.js** >= 18.x (used in `store` and `admin`)
- **Yarn** (recommended for consistent frontend installs)

---

## 📦 Local Setup Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/kenigbolo/marcus-shop.git
   cd marcus-shop
   ```

2. **Set up environment variables**:

   - Copy `.env.example` to `.env` inside both the `store/`, `admin/` and `/api` directories:
      ```bash
      cp api/.env.example api/.env
      cp store/.env.example store/.env
      cp admin/.env.example admin/.env
      ```

   - Fill in required variables (example below):
      ```env
      VITE_API_BASE_URL=http://localhost:3000/api
      VITE_USER_ID=3f2c1de2-b879-4f0e-980f-16a48db451c7 # Store
      VITE_ADMIN_ID=3f2c1de2-b879-4f0e-980f-16a48db451c7 # Admin
      ```
   - 

3. **Install frontend dependencies**:

   ```bash
   cd store && npm install
   cd ../admin && npm install
   ```

4. **(Optional)** If running Rails API directly without Docker:

   ```bash
   cd api
   bundle install
   rails db:create db:migrate db:seed
   ```

---

## 🐳 Docker Usage

From the project root, start everything with:

```bash
docker-compose up --build -d
```

Services will be available on:

| Service       | URL                   |
|---------------|------------------------|
| React Store   | http://localhost:5173  |
| Vue Admin     | http://localhost:4173  |
| Rails API     | http://localhost:3000  |

To seed the Rails database via Docker:

```bash
docker-compose exec api rails db:drop db:create db:migrate db:seed
```

To clean up docker and run a fresh build, from the root folder run:

```bash
chmod +x reset_and_rebuild.sh

./reset_and_rebuild.sh
```

---

## 🧪 Dev Notes

This repo uses the following tech:

- **React + Vite** for `store/`
- **Vue + Vite** for `admin/`
- **Rails 8 API-only** for backend

Data structure allows creating products → parts → part_options.

Cart logic handles part selection and price overrides based on conditions.

---

## 🧪 Tests

To run the tests you can run them via either docker or directly within the app

- Running via docker
   ```bash
   docker compose exec store npx vitest run
   ```
   ```bash
   docker compose exec admin npx vitest run
   ```
   ```bash
   docker compose exec api bundle exec rspec
   ```
- Running within the apps
   ```bash
   cd store && npx vitest run
   ```
   ```bash
   cd admin && npx vitest run
   ```
   ```bash
   cd api && bundle exec rspec
   ```

## 🧩 Features Implemented

### Rails API
- UUID-based models for products, parts, options, constraints, pricing
- Seeded realistic data with Faker
- API authentication via `X-User-ID` header
- Endpoints: Read more [here](./API.md)


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
- [x] Enforce constraints (e.g. invalid combinations)
- [x] Filter out-of-stock options
- [x] Support quantity update and checkout
- [ ] Support checkout

### Storefront
- [ ] Persist cart with localStorage
- [x] Show real product/option names in cart
- [x] Edit quantity in cart page
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


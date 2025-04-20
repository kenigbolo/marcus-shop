# 🧭 User Actions Reference Guide

This guide outlines all user-facing actions currently supported across the Storefront and Admin applications.

---

## 🛍 Storefront App (Bicycle Shop)

### 🧾 Product Browsing & Selection

- **View list of active products** on the homepage.
- **Click a product** to open the **Product Detail page**.
- **View all configurable parts** for the product, grouped by categories (e.g., frame, wheels).
- **Select one option per part** by clicking an available button:
  - Buttons toggle selection on/off.
  - Out-of-stock options are hidden from display.
- **See total price** dynamically update based on:
  - The base price of selected options.
  - Any applicable **conditional pricing** between selected options.

### 🛒 Cart Management

- **Add configuration to cart**:
  - Sends the product ID and all selected part option IDs to the backend.
  - The backend calculates conditional pricing and stores the item.
- **Toast notifications** show success or failure for adding to cart.
- **Cart summary view** shows:
  - Product name
  - Selected options
  - Price per item
  - Quantity
  - Subtotal
- **Remove an item** from the cart.
- **Edit an item** in the cart.
- **See updated subtotal** upon item removal.

---

## ⚙️ Admin App

### 📦 Product Management

- View list of all products.
- View product details including parts and part options.
- Add/Edit/Delete parts and part options.

### 💰 Conditional Pricing

- **Access conditional pricing UI** from a part option row.
- **View all existing conditional prices** for the selected part option.
- **Add a new conditional price**:
  - Choose a context part.
  - Select a context option.
  - Enter a price override.
  - The current part and its options are **excluded** from selection to prevent self-reference.
- **Edit or delete** existing conditional prices.

### 🎉 Option Constraints

- **Access option constraints UI** from a part option row.
- **View all existing option constriants** for the selected part option.
- **Add a new option constraint**:
  - Choose a context part.
  - Select a context option.
  - choose the constraint between **prohibits** and **requires**.
  - The current part and its options are **excluded** from selection to prevent self-reference.
- **Edit or delete** existing option constraints.

---

## 🧪 Testing

- Rails backend: Full request spec coverage for:
  - Products
  - Parts
  - PartOptions
  - ConditionalPrices
  - Carts and CartItems
  - Options Constraints
- Storefront: Frontend tests with Vitest + Testing Library
- Admin: Vue components tested manually (E2E testing optional)

---

## 🗂️ Future Enhancements

- Implement **option constraints** enforcement.
- Add **checkout flow** to cart.
- Add **user authentication**.
- Expand **admin dashboard** for filtering and metrics.

---

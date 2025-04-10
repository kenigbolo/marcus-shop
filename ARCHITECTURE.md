# ARCHITECTURE.MD

## Overview
This document describes the architecture for an e-commerce platform that allows Marcus, a bicycle shop owner, to sell customizable bicycles online. The system is designed to support future expansion into other sports-related products and includes flexibility for managing complex product customizations, pricing logic, and inventory constraints.

The system is composed of three major components:
- **API Layer (Ruby on Rails)**: Handles business logic, data management, and exposes RESTful/GraphQL endpoints.
- **Online Storefront (React)**: Customer-facing UI for browsing, customizing, and purchasing products.
- **Admin Panel (Vue)**: Admin interface for managing products, parts, inventory, and pricing.

---

## 1. Data Model

We use a **relational database** for structured relationships, constraints, and flexible querying.

### Tables

#### `products`
| Field       | Type     | Description                         |
|-------------|----------|-------------------------------------|
| id          | UUID     | Primary key                         |
| name        | string   | Product name                        |
| category    | string   | e.g., bicycle, ski                  |
| description | text     | Description of the product          |
| is_active   | boolean  | Visibility on the storefront        |

#### `parts`
| Field       | Type     | Description                         |
|-------------|----------|-------------------------------------|
| id          | UUID     | Primary key                         |
| product_id  | UUID     | FK to `products.id`                 |
| name        | string   | e.g., Frame, Wheels, Chain          |

#### `part_options`
| Field        | Type     | Description                         |
|--------------|----------|-------------------------------------|
| id           | UUID     | Primary key                         |
| part_id      | UUID     | FK to `parts.id`                    |
| name         | string   | Option name                         |
| base_price   | decimal  | Default price for the option        |
| stock_status | enum     | available / out_of_stock            |

#### `option_constraints`
| Field               | Type     | Description                               |
|---------------------|----------|-------------------------------------------|
| id                  | UUID     | Primary key                               |
| part_option_id      | UUID     | FK to `part_options.id`                   |
| constraint_type     | enum     | prohibits / requires                      |
| related_option_id   | UUID     | FK to another `part_options.id`           |

#### `conditional_prices`
| Field              | Type     | Description                               |
|--------------------|----------|-------------------------------------------|
| id                 | UUID     | Primary key                               |
| option_id          | UUID     | Affected option ID                        |
| context_option_id  | UUID     | Influencing option ID                     |
| price_override     | decimal  | Conditional price override                |

#### `carts`
| Field       | Type     | Description                         |
|-------------|----------|-------------------------------------|
| id          | UUID     | Primary key                         |
| user_id     | UUID     | FK to user                          |
| created_at  | datetime | Timestamp of creation               |

#### `cart_items`
| Field       | Type     | Description                         |
|-------------|----------|-------------------------------------|
| id          | UUID     | Primary key                         |
| cart_id     | UUID     | FK to `carts.id`                    |
| product_id  | UUID     | Product being configured            |
| quantity    | int      | Quantity of this item               |

#### `cart_item_options`
| Field          | Type     | Description                        |
|----------------|----------|------------------------------------|
| id             | UUID     | Primary key                        |
| cart_item_id   | UUID     | FK to `cart_items.id`              |
| part_option_id | UUID     | FK to `part_options.id`            |
| price_applied  | decimal  | Final price after evaluation       |

---

## 2. Main User Actions

- **Browse Products:** View all available products.
- **Customize Product:** Select from available part options with constraint and stock validation.
- **Add to Cart:** Store customized product with pricing breakdown.
- **Checkout:** Purchase selected items.

---

## 3. Product Page (Read Operation)

### UI (React Storefront)
- Visual live preview
- Grouped selectors for each part
- Dynamic price calculation

### Logic (Rails API)
- Fetch all options per part
- Filter out unavailable ones (stock)
- Apply constraint rules
- Base + conditional pricing resolution

---

## 4. Add to Cart

### Workflow
- Validate configuration via API
- Calculate final prices
- Persist `cart_item` and `cart_item_options`

---

## 5. Administrative Workflows (Vue Admin Panel)

- **Manage Inventory:** Update stock statuses.
- **Product Management:** Create/edit products and parts.
- **Constraint Setup:** Define incompatible combinations.
- **Price Management:** Base and conditional prices editing.

---

## 6. New Product Creation

### Admin Input
- Product metadata
- Parts and options with prices
- Optional constraints and conditional prices

### Database Impact
- Insert into `products`, `parts`, and `part_options`

---

## 7. Adding a New Part Choice

### Example
Add "Green" rim color.

### UI
- Navigate to rim part in Vue admin panel
- Add new option with price and availability

### DB Change
- Insert into `part_options`

---

## 8. Setting Prices

### Base Price
- Inline editing for each option

### Conditional Price
- Define rule via UI: Affected Option + Context Option + Override Price

### DB
- Insert into `conditional_prices`

---

## Core Classes (Ruby-style Pseudocode)

```ruby
class Product
  attr_accessor :id, :name, :parts
end

class Part
  attr_accessor :id, :name, :options
end

class PartOption
  attr_accessor :id, :name, :base_price, :stock_status, :constraints
end

class OptionConstraint
  attr_accessor :constraint_type, :related_option_id
end

class ConditionalPrice
  attr_accessor :option_id, :context_option_id, :price_override
end

class CartItem
  attr_accessor :id, :product_id, :selected_options
end
```

---


---
name: Refactor Safely - Extract Reusable Logic
description: Safely extract tightly-coupled logic from React components into reusable hooks or utilities while preserving component behavior
author: GitHub Copilot
tags:
  - refactoring
  - react
  - best-practices
  - testing
  - code-quality
---

# Refactor Safely: Extract Reusable Logic

## Overview

This skill describes how to identify tightly-coupled logic in React components and extract it into standalone, testable utilities or custom hooks. The goal is to improve maintainability, testability, and reusability without changing the component's external behavior or rendering output.

**Key principle:** Extract first, refactor component second. This ensures the component always has a working fallback and changes can be validated incrementally.

## When to Use

Extract logic when:
- **Logic is repeated** across multiple components
- **Logic is testable in isolation** (pure functions with no side effects)
- **Logic obscures component intent** (calculation methods, data transformations hide the UI/interaction logic)
- **Logic will grow** (you anticipate future enhancements or conditional branches)
- **Component file is long** (splitting concerns improves readability)

**Do NOT extract if:**
- Logic is tightly bound to component state updates (e.g., form field validation with async checks)
- Extraction would require prop-drilling or context overuse
- The logic is a one-liner (too simple to isolate)

## Instructions

### 1. Identify the Candidate Logic
- Scan the component for methods/inline functions
- Look for logic that doesn't directly manipulate component state or trigger renders
- Verify it's **pure** (same inputs → same outputs, no side effects)

### 2. Extract to a Utility/Hook
- **For pure calculations:** Create a standalone utility function in `src/hooks/` or `src/utils/`
- **For logic that uses React state:** Create a custom hook (e.g., `useMyLogic()`)
- Include JSDoc comments explaining parameters and return values

### 3. Preserve Component Behavior
- Keep the component's UI and interaction identical
- If the component called `calculatePrice()`, replace with `const price = usePriceCalculation(inputs)`
- Test rendering before/after (should be pixel-perfect)

### 4. Add Reusability Markers
- Export the utility/hook as a named export
- Document where it's used or can be used
- Consider adding simple unit tests if complex

### 5. Commit and Review
- Small commit: "Extract [logic name] into [new file]"
- Verify no console errors, no changed behavior
- Push to remote for CI validation

## Output Format

**New File:** `src/hooks/useMyLogic.js` or `src/utils/myLogic.js`
```javascript
/**
 * [Brief description]
 * @param {Type} param1 - Description
 * @returns {Type} Description
 */
export function useMyLogic(param1, param2) {
  // Pure logic here
  return result
}
```

**Updated Component:** Same number of lines or fewer, clearer intent
```jsx
import { useMyLogic } from '../hooks/useMyLogic'

export default function MyComponent() {
  // ... other state
  const result = useMyLogic(inputs)
  
  return (/* same UI */)
}
```

## Example

### Before Refactor
```jsx
// store/src/pages/ProductDetail.jsx
export default function ProductDetail() {
  const [product, setProduct] = useState(null)
  const [selectedOptions, setSelectedOptions] = useState({})

  const calculateTotalPrice = () => {
    if (!product || !product.parts) return 0
    const selectedOptionList = Object.values(selectedOptions)
    let total = 0

    for (const part of product.parts) {
      const selectedId = selectedOptions[part.id]
      const option = part.part_options?.find(opt => opt.id === selectedId)
      if (!option) continue

      const condition = option.conditional_prices?.find(cp =>
        selectedOptionList.includes(cp.context_option_id)
      )

      const finalPrice = Number((condition?.price_override ?? option.base_price) ?? 0)
      total += finalPrice
    }

    return total
  }

  return (
    <div>
      <p>Total: €{calculateTotalPrice().toFixed(2)}</p>
    </div>
  )
}
```

### After Refactor

**New file:** `store/src/hooks/usePriceCalculation.js`
```javascript
/**
 * Calculates total price with conditional pricing
 * @param {Object} product - Product with parts and options
 * @param {Object} selectedOptions - Map of partId -> optionId
 * @returns {number} Total calculated price
 */
export function usePriceCalculation(product, selectedOptions) {
  if (!product?.parts) return 0

  return product.parts.reduce((total, part) => {
    const selectedId = selectedOptions[part.id]
    const option = part.part_options?.find(opt => opt.id === selectedId)
    if (!option) return total

    const selectedOptionList = Object.values(selectedOptions)
    const condition = option.conditional_prices?.find(cp =>
      selectedOptionList.includes(cp.context_option_id)
    )

    const finalPrice = Number((condition?.price_override ?? option.base_price) ?? 0)
    return total + finalPrice
  }, 0)
}
```

**Updated component:** `store/src/pages/ProductDetail.jsx`
```jsx
import { usePriceCalculation } from '../hooks/usePriceCalculation'

export default function ProductDetail() {
  const [product, setProduct] = useState(null)
  const [selectedOptions, setSelectedOptions] = useState({})

  const totalPrice = usePriceCalculation(product, selectedOptions)

  return (
    <div>
      <p>Total: €{totalPrice.toFixed(2)}</p>
    </div>
  )
}
```

**Benefits:**
- ✅ `usePriceCalculation` can now be imported and tested independently
- ✅ ProductDetail is 15 lines shorter, intent clearer
- ✅ Reusable in CartSummary, checkout preview, or any other component
- ✅ Rendered output identical (safe refactor proven)

/**
 * Custom hook for calculating total price with conditional pricing
 * @param {Object} product - Product object with parts and options
 * @param {Object} selectedOptions - Map of partId -> optionId selections
 * @returns {number} Total calculated price
 */
export function usePriceCalculation(product, selectedOptions) {
  if (!product?.parts) return 0

  return product.parts.reduce((total, part) => {
    const selectedId = selectedOptions[part.id]
    const option = part.part_options?.find(opt => opt.id === selectedId)
    if (!option) return total

    // Check if any selected option has a conditional price for this option
    const selectedOptionList = Object.values(selectedOptions)
    const condition = option.conditional_prices?.find(cp =>
      selectedOptionList.includes(cp.context_option_id)
    )

    // Use conditional price override if available, otherwise base price
    const finalPrice = Number((condition?.price_override ?? option.base_price) ?? 0)
    return total + finalPrice
  }, 0)
}

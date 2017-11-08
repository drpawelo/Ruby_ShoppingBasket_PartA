class CashierEngine
  def self.calculate_price(shopping_item, quantity)
    starting_price = shopping_item.price_base * quantity.to_f
    final_price = starting_price
    shopping_item.discounts.each do |discount|
      final_price = discount.apply(final_price, quantity)
    end
    final_price
  end
end
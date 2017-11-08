class CashierEngine
  def self.calculate_price(shopping_item, quantity)
    shopping_item.price_base * quantity.to_f
  end
end
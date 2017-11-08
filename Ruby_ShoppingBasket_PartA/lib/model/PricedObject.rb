class PricedObject
  attr_accessor :name, :price_initial, :discounts

  def initialize(name, price_initial =  0.0, discounts = [])
    @price_initial = price_initial
    @name = name.to_s
    @discounts = discounts
  end

  def price_base
    price_initial
  end

  def price
    price_for(1)
  end

  def price_for(amount)
    CashierEngine.calculate_price(self, amount).round(2)
  end

end
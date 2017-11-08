require "#{__dir__}/PricedObject"

class ShoppingBasket < PricedObject

  attr_accessor :items

  def initialize(name = 'basket', price_initial = 0.0, discounts = [])
    super(name, price_initial, discounts)
    @items = Hash.new
  end

  def add(item_to_add)
    items[item_to_add] ? items[item_to_add] += 1 : items[item_to_add] = 1
  end

  def remove(item_to_remove)
    items[item_to_remove] -= 1 unless items[item_to_remove].nil?
    items.delete(item_to_remove) if items[item_to_remove] <= 0 #clean up
  end

  def empty
    @items = Hash.new
  end

  def price_base
    price_sum_of_items = price_initial
    items.each do |shopping_item, quantity|
      price_sum_of_items += CashierEngine.calculate_price(shopping_item, quantity)
    end
    price_sum_of_items
  end

  def total_items
    result = 0
    items.each {|shopping_item, quantity| result += quantity }
    result
  end

  def receipt
    result_string = '--------------------'
    result_string += "\nItems in basket: (#{total_items})"
    items.each  do  |item, amount|
      items_cost = (item.price_for(amount.to_f)).round(2)
      result_string += "\n#{item.name} * #{amount} \t\t#{items_cost.as_price}"
      result_string += " * OFFER" if item.discounts.count > 0
    end
    result_string += "\n\nTOTAL:\t\t\t#{ price.as_price}"
    result_string += " * OFFER" if discounts.count > 0
    result_string += "\n--- Have a nice day --"
    result_string
  end
end
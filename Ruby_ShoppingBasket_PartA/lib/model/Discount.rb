class Discount
  attr_accessor :type, :requirement, :discount_amount

  def initialize(type, requirement = 0.0, discount_amount = 0.0)
    @type = type
    @requirement = requirement
    @discount_amount = discount_amount
  end


  def apply(price_total_before_discount, quantity)

    price_after_discount = case type
             when :percent_discount then price_total_before_discount * (1.0 - discount_amount)
             when :if_over_price_then_percent_discount then price_total_before_discount > requirement ? price_total_before_discount * (1.0 - discount_amount)  : price_total_before_discount
             when :buy_some_get_last_discounted_discount then
                              discounted_items_quantity = (quantity / requirement).floor
                                discounted_items_price = (discounted_items_quantity.to_f / quantity.to_f) * (1.0 - discount_amount) * price_total_before_discount
                                not_discounted_items_price = (quantity - discounted_items_quantity).to_f / quantity.to_f * price_total_before_discount
                               discounted_items_price + not_discounted_items_price
             else price_total_before_discount
           end
    price_after_discount
  end
end
# A. You need to model a shopping basket.  We must be able to:
# add items to the shopping basket
# remove items from the shopping basket
# empty the shopping basket
# calculate the total of the shopping basket

# B. For the second half of the code test we’d like you to come in, pair up with one of us and attempt the following:-
# Buy-one-get-one-free discounts on items
# 10% off on totals greater than £20 (after bogof)
# 2% off on total (after all other discounts) for customers with loyalty cards.


# https://ruby-doc.org/core-2.2.0/Array.html

require "#{__dir__}/../lib/classes"
require "minitest/autorun"


class TestShoppingBasket_AddingItems < MiniTest::Test
  def setup
    @apple = PricedObject.new("apple", 0.11)
    @pear = PricedObject.new("pear", 0.22)
    @irnbru = PricedObject.new("irnbru", 0.55)
    @basket = ShoppingBasket.new
  end

  def teardown
    puts @basket.receipt
  end

  # helper methods
  def add_many_items
    @basket.add(@apple)
    @basket.add(@pear)
    @basket.add(@pear)
    @basket.add(@irnbru)
    @basket.add(@irnbru)
    @basket.add(@irnbru)
  end

  #  tests
  def test_add_one_item
    @basket.add(@apple)
    assert(@basket.items[@apple] == 1)
  end

  def test_add_many_items
    add_many_items
    assert(@basket.items[@apple] == 1)
    assert(@basket.items[@pear] == 2)
    assert(@basket.items[@irnbru] == 3)
  end

  def test_remove_items
    test_add_many_items
    @basket.remove(@apple)
    @basket.remove(@irnbru)
    @basket.remove(@irnbru)

    assert(@basket.items[@apple].nil?)
    assert(@basket.items[@pear] == 2)
    assert(@basket.items[@irnbru] == 1)
  end

  def test_empty_basket
    add_many_items
    @basket.empty

    assert(@basket.items[@apple].nil?)
    assert(@basket.items[@pear].nil?)
    assert(@basket.items[@irnbru].nil?)
  end

  def test_calculate_total_simple
    @basket.add(@apple)
    assert(@basket.price == 0.11)
  end

  def test_calculate_total_complex
    add_many_items
    assert(@basket.price == 2.20) # 0.11 + 0.22 * 2 + 0.55 * 3
  end


  def test_buy_one_get_one
    add_many_items
    discount = Discount.new(:buy_some_get_last_discounted_discount, 2, 1.0)
    @pear.discounts.push(discount)
    assert(@basket.price == 1.98) # 0.11 +  (0.22 * 2) - 0.22 + 0.55 * 3
  end

  def test_discount_over_2
    add_many_items
    discount = Discount.new(:if_over_price_then_percent_discount, 2.0, 0.10)
    @basket.discounts.push(discount)
    assert(@basket.price == 1.98) # 2.20 * 0.9
  end

  def test_discount_over_1_and_bogof_combo_enough
    add_many_items
    discount_bogof = Discount.new(:buy_some_get_last_discounted_discount, 2.0, 1.0)
    @pear.discounts.push(discount_bogof)
    discount = Discount.new(:if_over_price_then_percent_discount, 1.0, 0.10)
    @basket.discounts.push(discount)
    assert(@basket.price == 1.78) #1.98 is not enough
  end

  def test_discount_over_2_and_bogof_combo_not_enough
    add_many_items
    discount_bogof = Discount.new(:buy_some_get_last_discounted_discount, 2.0, 1.0)
    @pear.discounts.push(discount_bogof)
    discount = Discount.new(:if_over_price_then_percent_discount, 2.0, 0.10)
    @basket.discounts.push(discount)
    assert(@basket.price == 1.98) #1.98 is not enough
  end

  def test_total_discount
    add_many_items
    discount = Discount.new(:percent_discount, 0.0, 0.02) #33% discount
    @basket.discounts.push(discount)
    assert(@basket.price == 2.16) # 0.11 +  (0.22 * 2) + 0.55 * 3 = 2.20 * 0.98
  end
end
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
    @irnbru = PricedObject.new("IRN BRU", 0.55)
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
end
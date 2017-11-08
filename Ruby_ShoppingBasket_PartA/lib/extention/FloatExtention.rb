class Float
  def as_price
    "£#{'%.2f' % self}"
  end
end
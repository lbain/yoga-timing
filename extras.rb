# extend Integer class to include factorials
class Integer
  def factorial
    (1..self).reduce(:*)
  end

  def triangle
    (1..self).reduce(:+)
  end
end
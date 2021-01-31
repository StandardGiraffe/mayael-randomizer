class Card
  attr_reader :name
  attr_accessor :quantity

  def initialize(card_line: "", name: nil, quantity: nil)
    @name = name || card_line.scan(/name="(.+)"/).flatten.first
    @quantity = quantity || card_line.scan(/<card number="(.+)" /).flatten.first.to_i
  end
end

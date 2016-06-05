require_relative './factory.rb'
require_relative './idcard.rb'

class IDCardFactory < Factory
  attr_reader :owners

  def initialize
    @owners = []
  end
  
  def create_product(owner)
    return IDCard.new(owner)
  end

  def register_product(product)
    @owners += [product]
  end
end

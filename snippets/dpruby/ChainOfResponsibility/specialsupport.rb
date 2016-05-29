class SpecialSupport < Support
  def initialize(name,number)
    super(name)
    @number = number
  end

  def resolve(trouble)
    trouble.number == @number
  end
end

class LimitSupport < Support
  def initialize(name,limit)
    super(name)
    @limit = limit
  end

  def resolve(trouble)
    trouble.number < @limit
  end
end

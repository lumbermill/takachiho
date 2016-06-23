class Manager
  def initialize
    @showcase = {}
  end

  def register(name,product)
    @showcase[name] = product
  end

  def create(name)
    p = @showcase[name]
    p.clone # dup?
  end
end

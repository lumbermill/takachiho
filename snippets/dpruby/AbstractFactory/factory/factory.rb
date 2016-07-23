
class Factory
  def self.get(name)
    cls = eval name+"Factory"
    cls.new
  end
end

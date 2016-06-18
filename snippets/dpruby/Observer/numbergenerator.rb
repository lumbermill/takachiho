class NumberGenerator
  def initialize
    @observers = []
  end

  def add_observer(ob)
    @observers += [ob]
  end

  def notify_observers
    @observers.each do |ob|
      ob.update(self)
    end
  end
end

class Support
  def initialize(name)
    @name = name
  end

  def next(support)
    @next = support
  end

  def support(trouble)
    if resolve(trouble)
      done(trouble)
    elsif @next
      @next.support(trouble)
    else
      fail(trouble)
    end
  end

  def to_s
    "Support #{@name}"
  end

  private
    def done(trouble)
      puts "#{trouble} is resolved by #{self}."
    end

    def fail(trouble)
      puts "#{trouble} can not be resolved."
    end
end

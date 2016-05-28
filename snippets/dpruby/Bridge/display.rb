class Display
  def initialize(impl)
    @impl = impl
  end

  def open
    @impl.raw_open
  end

  def print
    @impl.raw_print
  end

  def close
    @impl.raw_close
  end

  def display
    open
    print
    close
  end
end

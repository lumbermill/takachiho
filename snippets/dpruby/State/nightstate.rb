class NightState
  include Singleton
  def do_clock(context,hour)
    if 9 <= hour && hour < 17
      context.change_state(DayState.instance)
    end
  end

  def do_use(context)
    context.call_security_center("!!The safe is going to be opened at night!!")
  end

  def do_alarm(context)
    context.call_security_center("Emergency Bell(night)")
  end

  def do_phone(context)
    context.log("Recording(night)")
  end

  def to_s
    "[night]"
  end
end

  
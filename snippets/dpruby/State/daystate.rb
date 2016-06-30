class DayState
  include Singleton
  def do_clock(context,hour)
    if hour < 9 || 17 <= hour
      context.change_state(NightState.instance)
    end
  end

  def do_use(context)
    context.log("Use the safe(daytime)")
  end

  def do_alarm(context)
    context.call_security_center("Emergency Call(daytime)")
  end

  def do_phone(context)
    context.call_security_center("Normal Call(daytime)")
  end

  def to_s
    "[day]"
  end
end

  
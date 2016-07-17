#! /usr/bin/ruby
module ServoBlaster
  HORIZONTAL = "2"
  VERTICAL = "1"
  SB = "/dev/servoblaster"
  @@wait = 0.2 # sec to wait
  @@step = 10 # 0 to 200?
  @@debug = false

  def write(target,value)
    cmd = "#{target}=#{value}\n"
    print cmd if @@debug
    f = open(SB,"w")
    f.write(cmd)
    f.close
    sleep(@@wait)
  end

  def reset(pos="0%")
    write(HORIZONTAL,pos)
    write(VERTICAL,pos)
  end

  def left
    write(HORIZONTAL,"+"+@@step.to_s)
  end

  def right
    write(HORIZONTAL,"-"+@@step.to_s)
  end

  def down
    write(VERTICAL,"+"+@@step.to_s)
  end

  def up
    write(VERTICAL,"-"+@@step.to_s)
  end

  def self.debug=(debug)
    @@debug = debug
  end

  def self.step=(step)
    @@step = step
  end

  def self.wait=(wait)
    @@wait = wait
  end

  module_function :reset, :left, :right, :up, :down
end

if $0 == __FILE__
  ServoBlaster.debug = true
  ServoBlaster.step = 15
  puts "Starting demos."
  include ServoBlaster
  3.times do
    reset("0%")
    reset("99%")
  end
  reset("50%")
  3.times do
    5.times { left; down }
    10.times { right; up }
    5.times { left; down }
  end
  puts "Fin."
end

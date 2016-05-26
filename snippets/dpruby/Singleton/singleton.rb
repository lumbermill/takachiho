require 'singleton'

class MySingleton
  include Singleton
  def initialize
    puts "New instance was created."
  end
end

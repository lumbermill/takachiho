require 'tk'
require 'tkextlib/tile'
require 'singleton'

require_relative './daystate.rb'
require_relative './nightstate.rb'

root = TkRoot.new {title "State"}
content = Tk::Tile::Frame.new(root) {padding "3 3 12 12"}.grid( :sticky => 'nsew')
TkGrid.columnconfigure root, 0, weight: 1
TkGrid.rowconfigure root, 0, weight: 1

$state = DayState.instance
$time = TkVariable.new
Tk::Tile::Label.new(content) {textvariable $time}.grid(column: 1, row: 1, columnspan:4, sticky: 'we')
$text = Tk::Text.new(content) {width 50; height 10}.grid(column: 1, row: 2, columnspan:4, sticky:'we')

Tk::Tile::Button.new(content) {text 'Use safe'; command {$state.do_use($context)}}.grid(column: 1, row:3, sticky: 'w')
Tk::Tile::Button.new(content) {text 'Emergency'; command {$state.do_alarm($context)}}.grid(column: 2, row:3, sticky: 'w')
Tk::Tile::Button.new(content) {text 'Call'; command {$state.do_phone($context)}}.grid(column: 3, row:3, sticky: 'w')
Tk::Tile::Button.new(content) {text 'End'; command {exit}}.grid(column: 4, row:3, sticky: 'w')

class Context
  include Singleton
  def change_state(state)
    $text.insert(1.0,"Changed from #{$state} to #{state}.\n")
    $state = state
  end

  def call_security_center(msg)
    $text.insert(1.0,"Call! #{msg}\n")
  end

  def log(msg)
    $text.insert(1.0,"Recording .. #{msg}\n")
  end
end

$context = Context.instance

Thread.new do
  24.times do |i|
    $time.value = "%02d:00" % i
    $state.do_clock($context,i)
    sleep 1
  end
end

Tk.mainloop
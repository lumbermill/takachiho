require 'tk'
require 'tkextlib/tile'

require_relative './macrocommand.rb'
require_relative './drawcommand.rb'

$history = MacroCommand.new

root = TkRoot.new {title "Command"}
content = Tk::Tile::Frame.new(root) {padding "3 3 12 12"}.grid(sticky: 'nsew')
TkGrid.columnconfigure root, 0, weight: 1
TkGrid.rowconfigure root, 0, weight: 1

Tk::Tile::Button.new(content) {text 'Clear'; command {clear}}.grid(column: 1, row:1, sticky: 'w')
Tk::Tile::Button.new(content) {text 'Undo'; command {undo}}.grid(column: 2, row:1, sticky: 'w')
$canvas = TkCanvas.new(content) {}.grid(column: 1, row: 2, columnspan: 2, sticky: 'w')

$canvas.bind( "B1-Motion", proc{|x, y| drawDot(x,y)}, "%x %y")

def drawDot(x,y)
  c = DrawCommand.new($canvas,[x,y])
  $history.append(c)
  c.execute
end

def undo
  $history.undo
  $canvas.delete("all")
  $history.execute
end

def clear
  $history.clear
  $canvas.delete("all")
end

Tk.mainloop
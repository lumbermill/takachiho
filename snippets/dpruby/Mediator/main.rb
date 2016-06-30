require 'tk'
require 'tkextlib/tile'

root = TkRoot.new {title "Mediator"}
content = Tk::Tile::Frame.new(root) {padding "3 3 12 12"}.grid( :sticky => 'nsew')
TkGrid.columnconfigure root, 0, weight: 1
TkGrid.rowconfigure root, 0, weight: 1

$userid = TkVariable.new; $password = TkVariable.new; $radio = TkVariable.new("Guest")
guest_radio = Tk::Tile::RadioButton.new(content) {text "Guest"; variable $radio; value "Guest"; command {mediate}}.grid(column: 1, row: 1, sticky: 'w')
login_radio = Tk::Tile::RadioButton.new(content) {text "Login"; variable $radio; value "Login"; command {mediate}}.grid(column: 2, row: 1, sticky: 'w')
Tk::Tile::Label.new(content) {text 'Username:'}.grid( :column => 1, :row => 2, :sticky => 'we')
$userid_entry = Tk::Tile::Entry.new(content) {width 20; textvariable $userid}.grid( :column => 2, :row => 2, :sticky => 'we' )
Tk::Tile::Label.new(content) {text 'Password:'}.grid( :column => 1, :row => 3, :sticky => 'we');
$password_entry = Tk::Tile::Entry.new(content) {width 20; textvariable $password; show "*"}.grid( :column => 2, :row => 3, :sticky => 'we' )
$ok_button = Tk::Tile::Button.new(content) {text 'OK'; command {ok}}.grid( :column => 1, :row => 4, :sticky => 'w')
$cancel_button = Tk::Tile::Button.new(content) {text 'Cancel'}.grid( :column => 2, :row => 4, :sticky => 'w')

TkWinfo.children(content).each {|w| TkGrid.configure w, :padx => 5, :pady => 5}

$userid_entry.bind("KeyRelease") { userpass_changed }
$password_entry.bind("KeyRelease") { userpass_changed }

def mediate
  if $radio == "Guest"
    $userid_entry.state("disabled")
    $password_entry.state("disabled")
    $ok_button.state("!disabled")
  else
    $userid_entry.state("!disabled")
    userpass_changed
  end
end

def userpass_changed
  if $userid.to_s.length > 0
    $password_entry.state("!disabled")
    if $password.to_s.length > 0
      $ok_button.state("!disabled")
    else
      $ok_button.state("disabled")
    end
  else
    $password_entry.state("disabled")
    $ok_button.state("disabled")
  end
end

def ok
  exit
end

mediate
Tk.mainloop
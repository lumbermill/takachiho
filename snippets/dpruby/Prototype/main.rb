require_relative './messagebox.rb'
require_relative './underlinepen.rb'

manager = Manager.new
upen = UnderlinePen.new('~')
mbox = MessageBox.new('*')
sbox = MessageBox.new('/')
manager.register('strong message', upen)
manager.register('warning box', mbox)
manager.register('slash box', sbox)

p1 = manager.create('strong message')
p1.use('Hello, world!')
p2 = manager.create('warning box')
p2.use('Hello, world!')
p3 = manager.create('slash box')
p3.use('Hello, world!')

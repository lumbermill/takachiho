from mcpi import minecraft

mc = minecraft.Minecraft.create()

x, y, z = mc.player.getPos()

air = 0
wood_plank = 5
glass = 20
bed = 26
bookshelf = 47
door_wood = 64
stairs_cobblestone = 67

# reset
mc.setBlocks(x-5,y,z-5,x+15,y+15,z+15,air)


# body
mc.setBlocks(x+3,y,z+4,x+12,y+10,z+6,1)
mc.setBlocks(x+3,y+10,z+4,x+4,y+10,z+6,air)
mc.setBlocks(x+3,y+9,z+4,x+3,y+9,z+6,air)
mc.setBlocks(x+12,y+10,z+4,x+13,y+10,z+6,air)
mc.setBlocks(x+12,y+9,z+4,x+12,y+9,z+6,air)


# head
mc.setBlocks(x+5,y+11,z+1,x+10,y+18,z+5,1)
mc.setBlocks(x+5,y+11,z+1,x+6,y+16,z+1,air)
mc.setBlocks(x+9,y+11,z+1,x+10,y+16,z+1,air)
mc.setBlocks(x+7,y+11,z+1,x+8,y+11,z+1,air)


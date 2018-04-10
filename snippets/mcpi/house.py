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
mc.setBlocks(x,y,z,x+7,y+7,z+7,air)

# wall
mc.setBlocks(x+1,y,z+1,x+6,y+4,z+6,wood_plank)
mc.setBlocks(x+2,y+1,z+2,x+5,y+4,z+5,air)
# roof
mc.setBlocks(x+2,y+5,z+2,x+5,y+5,z+5,wood_plank)

# door
mc.setBlock(x+2,y+2,z+1,door_wood,8)
mc.setBlock(x+2,y+1,z+1,door_wood,4)
mc.setBlock(x+2,y,z,stairs_cobblestone,2)

# window
mc.setBlock(x+4,y+2,z+1,glass)
mc.setBlock(x+5,y+2,z+1,glass)

mc.setBlock(x+4,y+2,z+6,glass)
mc.setBlock(x+5,y+2,z+6,glass)

# furniture
mc.setBlock(x+2,y+2,z+5,bookshelf)
mc.setBlock(x+2,y+1,z+5,bookshelf)
mc.setBlock(x+5,y+1,z+2,bed,0)
mc.setBlock(x+5,y+1,z+3,bed,8)


# https://projects.raspberrypi.org/en/projects/getting-started-with-minecraft-pi

local cube_0 = "Ultimate Energy Cube_0"
local cube_1 = "Ultimate Energy Cube_1"
local cube_2 = "Ultimate Energy Cube_2"
local level_0,level_1,level_2 = 0
local mode = 0
local message = ""
modem = peripheral.wrap("back")
monitor = peripheral.wrap("left")
monitor.clear()
rednet.open("back")
--mode 0 mode normal
--mode 2 mode economie
--mode 1 mode boost

function console(message)
  local heure = tostring(os.time())
  local aAfficher = "["..heure.."] "..message
  print(aAfficher)
end

function check()
while 1 do
level_0 = modem.callRemote(cube_0,"getStored")
level_1 = modem.callRemote(cube_1,"getStored")
level_2 = modem.callRemote(cube_2,"getStored")
sleep(1)
end
end

function display()
print("monitoring initialized")
while 1 do
  monitor.clear()
  monitor.setCursorPos(1,1)
  monitor.write("stockage aux trois points de controle")
  monitor.setCursorPos(1,3)
  monitor.write("level 0:")
  monitor.setCursorPos(1,5)
  monitor.write("level 1:")
  monitor.setCursorPos(1,7)
  monitor.write("level 2:")
  monitor.setCursorPos(10,3)
  monitor.write(level_0)
  monitor.setCursorPos(10,5)
  monitor.write(level_1)
  monitor.setCursorPos(10,7)
  monitor.write(level_2)
  sleep(1)
end
end

function regulation()
local change = 0
while 1 do
  if (mode == 0) then
    if (level_2 <= 120000000) then
      mode = 1
	  change = 1
    end
    if (level_0 >= 128000) then
      mode = 2
	  change = 1
    end
  end
  if (mode == 1) then
    if (level_1 > 128000) then
	  mode = 0
	  change = 1
    end
  end
  if (mode == 2) then
    if (level_1 < 120000000) then
      mode = 1
    end
  end
  if change then
    change()
  end
  sleep(1)
end
end

function change()
rednet.send(2,mode)
if (mode == 0)then
  monitor.setBackgroudColor(16)
  console("activation du mode normal")
end
if (mode == 1) then
  monitor.setBackgroudColor(2)
  console("activation du mode booster")
end
if(mode == 2) then
  monitor.setBackgroudColor(32)
  console("activation du mode economie")
end
end


console("systeme initialise avec succes")
parallel.waitForAll(check,display,regulation)


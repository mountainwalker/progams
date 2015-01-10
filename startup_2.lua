local mode = 0
rednet.open("top")
modem = peripheral.wrap("top")
local status = {[1]=1,[2]=1,[3]=1,[4]=2,[5]=2,[6]=2}
local RPM-1 = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0}
local RPM_vars = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0}
--mode 0 mode normal
--mode 2 mode economie
--mode 1 mode boost
local turbine_1,turbine_2,turbine_3,turbine_4,turbine_5,turbine_6 = "","","","","","" -- nom des turbines peripheriques

function console(message)
  heure = tostring(os.time())
  print("["..heure.."] "..message)
end

function receive()
  local sender = 0
  local message = ""
  sender,message = rednet.receive()
  if (sender == 1) then
    mode = tonumber(message)
    print(mode)
    message = "passage en mode"..message
    console(message)
  end
end

function change()
  for (i=1,6) do
	local PeripheralName = "turbine_"..tostring(i)
	if (status[i] = 1) then	
	  modem.callRemote(PeripheralName, setInductorEngaged(false))
	  modem.callRemote(PeripheralName, setFluidlowRateMax(10))
	elseif (status[i] = 2) then
	  modem.callRemote(PeripheralName, setInductorEngaged(true))
	  modem.callRemote(PeripheralName, setFluidlowRateMax(2000))
    elseif (status [i] = 0)
	  modem.callRemote(PeripheralName, setActive(false))
	  local message = "reactor"..tostring(i).."dissbled"
	  console(message)
	end
  end
end

function adjust()
  while (mode == 1) do
    for (i=1,6) do
      local PeripheralName = "turbine_"..tostring(i)
      local RPM = modem.callRemote(PeripheralName,getRotorSpeed())
	  if (RPM <= 1750)then
	    if (RPM <= 1600) then
		modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())+10))
		else
		modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())+1))
		end
      elseif(RPM >= 1850) then
		if (RPM >= 2000) then
		  modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())-10))
		else
          modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())-1))
        end
      end
	end
  end
  while (mode == 0) do
    for (i=1,6) do
	  local PeripheralName = "turbine_"..tostring(i)
      local RPM = modem.callRemote(PeripheralName,getRotorSpeed())
	  if (RPM <= 1750)then
	    if (RPM <= 1600) then
		modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())+10))
		else
		modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())+1))
		end
      elseif(RPM >= 1850) then
		if (RPM >= 2000) then
		  modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())-10))
		else
          modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())-1))
        end
      end
	end
  end
  while (mode == 2) do
    for (i=1,6) do
	  local PeripheralName = "turbine_"..tostring(i)
      local RPM = modem.callRemote(PeripheralName,getRotorSpeed())
	  if (RPM <= 1750)then
	    if (RPM <= 1600) then
		modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())+10))
		else
		modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())+1))
		end
      elseif(RPM >= 1850) then
		if (RPM >= 2000) then
		  modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())-10))
		else
          modem.callRemote(PeripheralName,setFluidlowRateMax(modem.callRemote(PeripheralName, getFluidlowRateMax())-1))
        end
      end
	end
  end
  
  if (mode == 0) then
    status = {1,1,1,2,2,2}	
  elseif (mode == 1) then
    status = {2,2,2,2,2,2}
  elseif (mode == 2) then
    status = {1,1,1,1,1,1}
  end
  change()
end

receive()
parallel.waitForAll(receive,adjust)

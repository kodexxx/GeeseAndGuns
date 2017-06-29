c = love.thread.getChannel("serialdata")

local port = "com3";
local baud = 9600
os.execute("powershell $port= new-Object System.IO.Ports.SerialPort "..port..","..baud..",None,8,one;$port.open();$port.close();")

local serial = io.open(port,"r")

while true do 
	t = serial:read()
	c:push(t)
end
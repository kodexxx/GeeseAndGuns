x, y = 400, 600
score = 0

function love.load()
    love.window.setMode(800, 600, {vsync=false, minwidth=800, msaa=2, minheight=600, fullscreen=true})  
    love.window.setTitle("GeeseAndGuns")

    SPEED = 500
	ACCELERATION = 999999
	DECELERATION = 55555

	bg = love.graphics.newImage("bg.jpg")
	geese = love.graphics.newImage("bird.png")
	sun = love.graphics.newImage("sun.png")
	cloud = love.graphics.newImage("cloud.png")
	mainlogo = love.graphics.newImage("mainlogo.png")

	shot = love.audio.newSource("shot.mp3", "static")

	sunAngle = 0
	cloudx = -128
	cloudx1 = -128
	love.graphics.setBackgroundColor(52, 152, 219)
end

x = 0
cp = 0
vp = 0
blood = false
blood_timer = 6

shootmode = "game"
gamemode = "menu"
timeLimit = 59

t = "nope"

thread = love.thread.newThread("serial.lua")
channel = love.thread.getChannel("serialdata")
thread:start()


function newBird()
	x = 150
	cp = math.random(1, 4) / 1000
	vp = math.random(-1, 3) / 100
end
newBird()

function love.draw()
	love.graphics.setColor(255, 255, 255)	
	if shootmode == "game" then 
		if gamemode == "menu" then
			love.graphics.draw(sun, love.graphics.getWidth() - 50, 50, sunAngle*180/math.pi, 1, 1, 128, 128)
			love.graphics.draw(mainlogo, love.graphics.getWidth() / 2 - 352, 150)
			love.graphics.setColor(39, 174, 96)
			love.graphics.ellipse("fill", love.graphics.getWidth() / 2, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight()/5,60 )

			love.graphics.setColor(255,255,255)
			--love.graphics.draw(bg, 0, 0, 0) 
			love.graphics.setBackgroundColor(52, 152, 219)
		elseif gamemode == "play" then
			love.graphics.draw(cloud, cloudx, 35)
			love.graphics.draw(cloud, cloudx1, 190)
			love.graphics.draw(sun, love.graphics.getWidth() - 50, 50, sunAngle*180/math.pi, 1, 1, 128, 128)
			love.graphics.draw(geese, x, y) 
			love.graphics.setColor(39, 174, 96)
			love.graphics.ellipse("fill", love.graphics.getWidth() / 2, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight()/5,60 )

			love.graphics.setColor(255,255,255)
			--love.graphics.draw(bg, 0, 0, 0) 
			love.graphics.setBackgroundColor(52, 152, 219)

			if blood then
				love.graphics.setColor(255, 0, 0, 120)
				love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
			end

			love.graphics.setNewFont(70)
			love.graphics.print(score, 35, 35)
			love.graphics.setNewFont(60)
			love.graphics.print("00:" .. string.format("%2.0f", math.ceil(timeLimit)), love.graphics.getWidth() - 235, love.graphics.getHeight() - 100)
		elseif gamemode == "score" then
			love.graphics.draw(sun, love.graphics.getWidth() - 50, 50, sunAngle*180/math.pi, 1, 1, 128, 128)
			love.graphics.setNewFont(60)
			love.graphics.print("Score: " .. score, love.graphics.getWidth() / 2 - 70, love.graphics.getHeight() / 2 - 70)
			love.graphics.setColor(39, 174, 96)
			love.graphics.ellipse("fill", love.graphics.getWidth() / 2, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight()/5,60 )

			love.graphics.setColor(255,255,255)
			--love.graphics.draw(bg, 0, 0, 0) 
			love.graphics.setBackgroundColor(52, 152, 219)
		end
	elseif shootmode == "check" then
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", x, y + 80, 128, 128)
		love.graphics.setBackgroundColor(0, 0, 0)
	elseif shootmode == "blacksq" then
		love.graphics.setBackgroundColor(0, 0, 0)
	end

	love.graphics.setNewFont(12)
	love.graphics.setColor(243, 156, 18)
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )) .. " data: " .. t, 10, 10)
end


d = 15
function love.update(dt)
	
	d = d + dt

	v = channel:pop()
	if v == "bleed" then
		d = 0
		shootmode = "blacksq"
		shot:play()
	elseif v then
		t = v
		one, two = v:match("([^,]+) ([^,]+)")
		one = tonumber(one)
		two = tonumber(two)
		if two - one > 5 then 
			score = score + 1
			newBird()
			boold = true
			blood_timer = 0
		end
	end

	blood_timer = blood_timer + dt
	if blood_timer < 0.4 then
		blood = true
	else
		blood = false
	end


	if d <= 0.1 then
		shootmode = "blacksq"
	elseif d <= 0.2 then
		shootmode = "check"
	else
		shootmode = "game"
	end

	if love.keyboard.isDown("down") then
		shootmode = "check"
	elseif love.keyboard.isDown("up") then
		shootmode = "blacksq"
	end

	if gamemode == "menu" then
		if love.mouse.isDown(1) then
			gamemode = "play"
		end
	elseif gamemode == "play" then
		y = -cp*x*x + vp*x + 500
		x = x + 180*dt
		if y < -128 then
			newBird()
		end
		timeLimit = timeLimit - dt

		if timeLimit <= 0 then
			gamemode = "score"
		end
	end

	




	cloudx = cloudx + dt*200
	cloudx1 = cloudx1 + dt*290
	if cloudx > love.graphics.getWidth() + 64 then cloudx = -128 end
	if cloudx1 > love.graphics.getWidth() + 64 then cloudx1 = -128 end
	sunAngle = sunAngle + 0.01*dt

end


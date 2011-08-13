

love.graphics.setBackgroundColor(41, 126, 222)

-- scenery.bglayers = {}
-- scenery.fglayers = {}

scenery = class:new()
cloud = class:new()  -- platform class

function cloud:init(texture, x, y, scrolling, scale)
    self.texture = texture
	self.x = x
	self.y = y
	self.scrolling = scrolling
	self.scale = scale
end

function scenery:init(horizonY)
	self.horizonY = horizonY
	self.skyHeight = textures.bg:getHeight( );
	self.eyesHeight = 30 -- maybe a bit more is more realistic?
	
	self.clouds = { }
	
	self:addcloud(textures.cloud1, 250, -500, 0.5, 1)
	self:addcloud(textures.cloud2, 700, -500, 0.5, 1)
	self:addcloud(textures.cloud3, 450, -500, 0.3, 2)
	
	self:addcloud(textures.cloud3, 500, -500, -0.1, 3)
	self:addcloud(textures.cloud1, 300, -500, -0.3, 3)
	self:addcloud(textures.cloud2, 100, -500, -0.4, 3.5)
end

function scenery:addcloud(texture, x, y, scrolling, scale)
	cloud1 = cloud:new(texture, x, y, scrolling, scale)
	table.insert(self.clouds,cloud1)
end

function scenery:drawbg()
	self.width = love.graphics.getWidth()
	self.height = love.graphics.getHeight()
	
	love.graphics.setColor(255, 255, 255) --reset the drawing color to white
	cx = camera._x;
	cy = camera._y;
	-- groundcamy = 480;

	-- first draw the background scene
	love.graphics.draw(textures.bg, cx, 0, 0, width, 1 / self.skyHeight * self.horizonY	, 0, 0) -- draw the background and stretch it over the horizon. offset by camera.x so that it follows the view

	quad = love.graphics.newQuad(0, 0, width+32, height, 32, 32 )
	offsetX = cx % 32
	love.graphics.drawq(textures.underground, quad, cx-offsetX, self.horizonY )
	
	-- horizon=800 & height=600 = cam=480	horizon - height/2 - 20
	-- horizon=800 & height=800 = cam=380	horizon - height/2 - 20
	
	love.graphics.setColor(255, 240, 240, 255) -- adjust the sun colour a bit
	love.graphics.setBlendMode('additive')
	scenery:drawTexture(textures.sun, 100, -2500, cx, cy, 0.9, 1)
	love.graphics.setBlendMode('alpha')
	
	
	love.graphics.setColor(240, 255, 255, 255) -- adjust the clouds colour a bit
	love.graphics.setBlendMode('alpha')
	
	-- draw all clouds that aren't as close as the player
	for k,c in pairs(self.clouds) do 
		if c.scrolling >= 0 then
			self:drawTexture(c.texture, c.x, c.y, cx, cy, c.scrolling, c.scale)
		end
	end
	
	
	--[[
	-- further back = 1, closest = 0, closer than player < 0
	for k, d in pairs( { 1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0, -0.1, -0.2, -0.3 } ) do
		love.graphics.setColor(255*d, 255*d, 255*d, 255)
		yDiff = 0
		-- yDiff = + ((cy - (self.horizonY/2 + 20))*d)
		love.graphics.circle("fill", 100 + cx * d, self.horizonY-300 + yDiff, 20 * (1.1-d))
	end
	
	love.graphics.setColor(255, 255, 255, 255) --reset the drawing color to white
	love.graphics.print("cam: " .. cx .. ":" .. cy, cx + 10, cy + 10 )
	love.graphics.print("horizon: " .. self.horizonY, cx + 10, cy + 20 )
	love.graphics.print("player: " .. player.xpos .. ":" .. player.ypos, cx + 10, cy + 30)
	]] 
end

function scenery:drawTexture(texture, x, y, camx, camy, scrolling, scale)
	h = texture:getHeight();
	yCorrection = (y + self.horizonY - self.height/2 - self.eyesHeight)
	love.graphics.draw(texture, x + camx*scrolling, y-(h*scale)/2 + self.horizonY + (camy * scrolling - (yCorrection * scrolling)), 0, scale, scale, 0, 0)
end

function scenery:drawfg()
	love.graphics.setColor(240, 255, 255, 255) -- adjust the clouds colour a bit
	love.graphics.setBlendMode('alpha')
	-- draw all clouds that are closer than the player
	for k,c in pairs(self.clouds) do 
		if c.scrolling < 0 then
			self:drawTexture(c.texture, c.x, c.y, cx, cy, c.scrolling, c.scale)
		end
	end	
	love.graphics.setColor(255, 255, 255, 255) --reset the drawing color to white
end
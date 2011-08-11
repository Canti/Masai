-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- spear.lua

spear = class:new()  -- spear master class


function spear:init()

        self.xvel     = 0;
        self.yvel     = 0;
        self.maxvel   = 500;

        self.xpos     = 0;
        self.ypos     = 0;

        self.tip_xpos = 0;
        self.tip_ypos = 0;

        self.jab      = false;
        self.jab_dt   = 0;
        self.throw    = false;
        self.throw_dt = 0;

        self.angle    = 0;

        --let's create the spear - it's also a box2d physics object
        self.body   = love.physics.newBody(box2d.world, player.xpos, player.ypos, 1, 0);
        self.shape  = love.physics.newRectangleShape(self.body, 0, 0, 67, 8, 0);
        self.body:setAngularDamping(3.5); -- we don't want it to spin like crazy... yet..
        self.body:setMassFromShapes();    -- realistic mass
        self.shape:setRestitution(0);     -- not bouncy
        self.shape:setData("spear");      -- callback info
        self.shape:setCategory(1);        -- collision category
        self.shape:setMask(1);            -- don't collide with self or player

end

function spear:update(dt)

    self.xvel, self.yvel = self.body:getLinearVelocity();

--[[ -- the "limiting speed" code doesn't work well. it ruines the direction
    -- limit speed only when thrown or jabbed
    if self.jab or self.throw then
        if self.xvel > self.maxvel then
           self.body:setLinearVelocity(self.maxvel, self.yvel);
        elseif self.xvel < -self.maxvel then
           self.body:setLinearVelocity(-self.maxvel, self.yvel);
        end
        if self.yvel > self.maxvel then
           self.body:setLinearVelocity(self.xvel, self.maxvel);
        elseif self.yvel < -self.maxvel then
           self.body:setLinearVelocity(self.xvel, -self.maxvel);
        end
    end
]]
    -- if spear is thrown, count down time and then not thrown
    if self.throw then
       self.throw_dt = self.throw_dt + dt;
    end
    if self.throw_dt > 1.0 then
       self.throw_dt = 0;
       self.throw = false;
    end

    -- if spear is jabbed, count down time and then not jabbed
    if self.jab then
       self.jab_dt = self.jab_dt + dt;
    end
    if self.jab_dt > 0.075 then
       self.jab_dt = 0;
       self.jab = false;
    end

    if not self.throw and not self.jab then
        self.body:setAngle(mouse.angle);
        self.body:setX(player.xpos - (11 * player.facing));
        self.body:setY(player.ypos - 23);
    end

    self.angle = self.body:getAngle();
    self.xpos = self.body:getX();
    self.ypos = self.body:getY();

end

function spear:jab_attack()

    self.body:setAngularVelocity(0);
    self.jab = true;
--    self.maxvel = 50;

  	playervx, playervy = player.body:getLinearVelocity( );
		
	vx = mouse.xdist * 5;
	vy = mouse.ydist * 5 - 100;
	xabs=math.abs(vx);
	yabs=math.abs(vy);
	vz = math.sqrt(vx * vx + vy * vy);
	
	-- also add player velocity
	self.body:setLinearVelocity( vx * vz / (xabs+yabs) + playervx, vy * vz / (xabs+yabs) + playervy);	
    love.audio.play(sounds.jab);
end

--[[
function spear:jab_attack()

    self.body:setAngularVelocity(0);
    self.tip_xpos = (self.xpos + 33.5*math.cos(mouse.angle));
    self.tip_ypos = (self.ypos + 33.5*math.sin(mouse.angle));

    self.jab = true; self.maxvel = 50;

    self.body:applyImpulse( (mouse.xdist/100), (mouse.ydist/100), self.tip_xpos, self.tip_ypos );
    love.audio.play(sounds.jab);
end
]]

function spear:throw_attack()

    self.body:setAngularVelocity(0);
    self.throw = true; 
--	self.maxvel = 500;
    
	playervx, playervy = player.body:getLinearVelocity( );
		
	vx = mouse.xdist * 5;
	vy = mouse.ydist * 5 - 100;
	xabs=math.abs(vx);
	yabs=math.abs(vy);
	vz = math.sqrt(vx * vx + vy * vy);
	
	-- also add player velocity
	self.body:setLinearVelocity( vx * vz / (xabs+yabs) + playervx, vy * vz / (xabs+yabs) + playervy);	
	
    love.audio.play(sounds.throw);
end


--[[
function spear:throw_attack()

    self.body:setAngularVelocity(0);
    self.tip_xpos = (self.xpos + 33.5*math.cos(mouse.angle));
    self.tip_ypos = (self.ypos + 33.5*math.sin(mouse.angle));

    self.throw = true; self.maxvel = 500;
    self.body:applyImpulse( (mouse.xdist/50), (mouse.ydist/50), self.tip_xpos, self.tip_ypos );
    love.audio.play(sounds.throw);
end
]]
function spear:draw()

    love.graphics.draw(textures.spear, spear.xpos, spear.ypos, spear.angle,  1, 1,  35, 5);

end

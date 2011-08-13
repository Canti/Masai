-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- objects.lua


--objects = {}

object = class:new()

function object:create(x, y, w, h)
--         table.insert(objects, self)
         self.body  = love.physics.newBody(box2d.world, x, y, 0, 0)
         self.shape = love.physics.newRectangleShape(self.body, 0, 0, w, h, 0)
end


platform = object:new()  -- platform class
function platform:init(x, y, w, h)
         self:create(x, y, w, h)
         self.shape:setRestitution(0);
         self.shape:setCategory(2);
end

wall = object:new()  -- wall class -> wall's can't be 'climbed'
function wall:init(x, y, w, h)
         self:create(x, y, w, h)
         self.shape:setRestitution(0);
         self.shape:setCategory(2);
         self.shape:setData("wall");
end

pad = object:new()  -- pad class
function pad:init(x, y, w, h)
         self:create(x, y, w, h)
         self.shape:setRestitution(2);
         self.shape:setCategory(2);
         self.shape:setData("pad");
end

box = object:new()  -- box class
function box:init(x, y, w, h)
         self:create(x, y, w, h)
         self.body:setMassFromShapes();
         self.shape:setRestitution(0);
         self.shape:setCategory(2);
end

-- this function is not entirely my own
-- use it like so -> makeChain(platform1, platform2, numplanks, widthofeachplank);
function makeChain(object1, object2, chainObjects, numLinks, linkWidth)
	object1X, object1Y = object1.body:getPosition()
	object2X, object2Y = object2.body:getPosition()
	distance   = object2X - object1X -- order is important here! -- math.abs(object1X - object2X);
	linkLength = math.abs(distance / numLinks)
    chainJointObjects = {}
	for i=1, numLinks do
		chainObjects[i] = {}
		-- chainObjects[i].body  = love.physics.newBody(box2d.world, object1X + linkWidth*i + linkLength/2, object1Y, 10, 0)
		chainObjects[i].body  = love.physics.newBody(box2d.world, object1X + linkWidth*(i-1), object1Y, 10, 0)
		chainObjects[i].shape = love.physics.newRectangleShape(chainObjects[i].body,0, 0, linkWidth, 10, 0)
		chainObjects[i].shape:setFriction( 0.98 )
		
		--If the chain isn't the first one, link it to the previous chain created
		if i ~= 1 then
			chainJointObjects[i] = {}
			--chainJointObjects[i].joint = love.physics.newRevoluteJoint(chainObjects[i].body, chainObjects[i-1].body, (chainObjects[i-1].body:getX() + linkLength/2), chainObjects[i-1].body:getY())
			chainJointObjects[i].joint = linkBodies(chainObjects[i-1].body, chainObjects[i].body, linkWidth)
			chainJointObjects[i].joint:setCollideConnected(false)
		end

		chainObjects[i].shape:setCategory(3)
		chainObjects[i].body:setMassFromShapes();
		chainObjects[i].body:setAngularDamping( 5.5 )
		chainObjects[i].body:setLinearDamping( 5.5 )
		--chainObjects[i].body:setPosition
		chainObjects[i].shape:setMask(3)
	end
	
	--Create the pivot point for the first chain and object 1
	-- object1Joint = {}
	-- object1Joint = love.physics.newRevoluteJoint(chainObjects[1].body, object1.body, object1X + linkLength/2, object1Y)
	object1Joint = linkBodies(object1.body, chainObjects[1].body, linkWidth)
	object1Joint:setCollideConnected(false)

	--Create the pivot point for the last chain and object 2
	-- object2Joint = {}
	-- object2Joint = love.physics.newRevoluteJoint(chainObjects[numLinks].body, object2.body, object2X, object2Y)
	object2Joint = linkBodies(chainObjects[numLinks].body, object2.body, linkWidth)
	object2Joint:setCollideConnected(false)

	--Make it so that the objects don't collide with the chains
	object2.shape:setMask(3)
	object1.shape:setMask(3)
end

function linkBodies(body1, body2, len)
	b1X, b1Y = body1:getPosition()
	b2X, b2Y = body2:getPosition()
	
	-- --[[
	lH = len/2
	body1:setPosition(lH, 0)
	body2:setPosition(len+lH, 0)
	joint = love.physics.newRevoluteJoint(body1, body2, len+2, 0)
	--]]
	--[[ lH = len/2
	body1:setPosition(0, 0)
	body2:setPosition(len, 0)
	joint = love.physics.newRevoluteJoint(body1, body2, lH, 0) ]]
	
	body1:setPosition(b1X, b1Y)
	body2:setPosition(b2X, b2Y)
	return joint
end

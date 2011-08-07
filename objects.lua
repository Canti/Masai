-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- objects.lua


objects = {}

object = class:new()

function object:create(x, y, w, h)
         table.insert(objects, self)
         self.body  = love.physics.newBody(level.world, x, y, 0, 0)
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

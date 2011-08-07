-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- level.lua

level = class:new()

function level:init(w, h, g)

        self.world = love.physics.newWorld(-w, -h, w, h)
        self.world:setGravity(0, g) -- 500 is good
        self.world:setMeter(64) --the height of a meter in this world will be 64px
        self.world:setCallbacks(add, persist, rem, result)

end

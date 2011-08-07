-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- mouse.lua

mouse = class:new()  -- mouse master class


function mouse:init()

      love.mouse.setVisible(false)

end

function mouse:update()

      self.xpos, self.ypos = love.mouse.getPosition();
      self.xdist = self.xpos - spear.xpos;
      self.ydist = self.ypos - spear.ypos;

      self.angle = (math.atan2(self.ydist, self.xdist));  -- angle between the mouse and the spear

end

-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- gamestate.lua

gamestate = class:new()  -- sounds master class


function gamestate:init()

      self.paused      = false;
      self.fullscreen  = false;

end

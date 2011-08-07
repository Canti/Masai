-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- textures.lua

textures = class:new()  -- textures master class


function textures:load()

      self.cursor      = love.graphics.newImage("textures/cursor.png");

      self.spear       = love.graphics.newImage("textures/spear.png");

      self.masai_head  = love.graphics.newImage("textures/masai_head.png");
      self.masai_hand  = love.graphics.newImage("textures/masai_hand.png");
      self.masai_torso = love.graphics.newImage("textures/masai_torso.png");
      self.masai_foot  = love.graphics.newImage("textures/masai_foot.png");

      self.crate       = love.graphics.newImage("textures/crate.png");


end

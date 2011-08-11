-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- player.lua

player = class:new()  -- player master class


function player:init(x, y) -- x, y is the starting position of the player

      self.canJump   = false;
      self.canRun    = false;
      self.facing    = 1;  -- 1 for right and -1 for left
      self.running   = 1;  -- 1 for right and -1 for left

      self.xvel      = 0;
      self.yvel      = 0;
      self.maxvel    = 800;

      self.jumpPower = -2.3;
      self.runPower  = 8;
      self.airPower  = 2.8;
      self.movevel   = 220;

      self.xpos      = x;
      self.ypos      = y;

      self.torso_dt   = 0;
      self.torso_ypos = 0;

      self.moving     = false;
      self.feet_dt    = 0;
      self.foot1_xpos = 0; self.foot2_xpos = 0;
      self.foot1_ypos = 0; self.foot2_ypos = 0;

      -- the player is a box2d physics object
      self.body     = love.physics.newBody(box2d.world, self.xpos, self.ypos, 1, 0);
      self.shape    = love.physics.newCircleShape(self.body, 0, 0, 20) --the player's shape has no offset from it's body and has a radius of 20

      self.body:setAngularDamping(20.0); -- so that the circle doesn't spin much and make our player roll / slide around
      self.body:setMassFromShapes(); -- get a realistic mass
      self.shape:setRestitution(0);  -- not a bouncy player :p
      self.shape:setFriction(1.0);   -- also prevents sliding
      self.shape:setData("player");  -- collision data
      self.shape:setCategory(1);     -- collision category
      self.shape:setMask(1);         -- don't collide with self and spear

end

function player:update(dt)

      self.xvel, self.yvel = player.body:getLinearVelocity();
      self.xpos = player.body:getX();
      self.ypos = player.body:getY();

      -- limit x velocity
      if self.xvel > self.maxvel then
         self.body:setLinearVelocity(self.maxvel, self.yvel);
      elseif self.xvel < -self.maxvel then
         self.body:setLinearVelocity(-self.maxvel, self.yvel);
      end

      -- limit y velocity
      if self.yvel > self.maxvel then
         self.body:setLinearVelocity(self.xvel, self.maxvel);
      elseif self.yvel < -self.maxvel then
         self.body:setLinearVelocity(self.xvel, -self.maxvel);
     end

      -- face direction of mouse.x_pos
      if (mouse.xpos > self.xpos) then
         self.facing = 1;
      elseif (mouse.xpos < self.xpos) then
         self.facing = -1;
      end

      -- make the torso move up and down
      self.torso_dt    = self.torso_dt%math.pi + dt;
      self.torso_ypos  = math.sin(4*self.torso_dt);

      -- running feet animation
      if self.moving then
          self.feet_dt = self.feet_dt%math.pi + dt;
          -- <TechnoCat> A*sin(B*x)+C A=amplitude, 1/B = frequency, C=y-offset
          self.foot1_xpos, self.foot1_ypos = math.cos(12*self.feet_dt)*10,    math.sin(12*self.feet_dt)*4;
          self.foot2_xpos, self.foot2_ypos = math.cos(12*self.feet_dt+10)*10, math.sin(12*self.feet_dt+10)*4;
      else
          self.foot1_xpos, self.foot1_ypos =  5, -4;
          self.foot2_xpos, self.foot2_ypos = -5, -4;
      end

end

function player:moveLeft()

       if self.xvel > -self.movevel and self.canRun then
          self.body:applyForce(-self.runPower, 0)
       elseif self.xvel > -self.movevel then
          self.body:applyForce(-self.airPower, 0)
       end
end

function player:moveRight()

       if self.xvel < self.movevel and self.canRun then
          self.body:applyForce(self.runPower, 0)
       elseif self.xvel < self.movevel then
          self.body:applyForce(self.airPower, 0)
       end
end

function player:jump()

      self.body:applyImpulse(0, self.jumpPower, 10, 10)
end

function player:draw()

    love.graphics.draw(textures.masai_torso, player.xpos, (player.ypos - 20), 0, player.facing, 1,  10, player.torso_ypos);
    love.graphics.draw(textures.masai_head,  player.xpos, (player.ypos - 29), 0, player.facing, 1,   0, player.torso_ypos);
    love.graphics.draw(textures.masai_hand,  player.xpos, (player.ypos - 12), 0, player.facing, 1, -10, 0);
    if not (spear.jab) then
           love.graphics.draw(textures.masai_hand,  player.xpos, (player.ypos - 25), 0, player.facing, 1,  15, 0);
    else   love.graphics.draw(textures.masai_hand,  spear.xpos, spear.ypos, 0, player.facing, 1,  0, 0);
    end
    love.graphics.draw(textures.masai_foot,  player.xpos, player.ypos, 0, player.running, 1,  3 + player.foot1_xpos, -8 + player.foot1_ypos);
    love.graphics.draw(textures.masai_foot,  player.xpos, player.ypos, 0, player.running, 1,  3 + player.foot2_xpos, -8 + player.foot2_ypos);

end

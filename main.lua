-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- main.lua

require 'secs'      -- a LUA OO implementation by bartbes. http://love2d.org/wiki/SECS

require 'gamestate' -- variables for things like paused / menu etc.
require 'camera'    -- camera by BlackBulletIV
require 'mouse'     -- mouse distance / angle functions
require 'sounds'    -- load all our audio here
require 'textures'  -- load all our textures here

require 'box2d'     -- the world which holds all classes below
require 'player'    -- the player  class and associated functions
require 'spear'     -- the spear   class and associated functions



function love.load()

  gamestate:init();
  mouse:init();
  sounds:load();
  textures:load();

  -- need to create a system for loading different levels
  require 'levels/level1'

  --initial graphics setup
  love.graphics.setCaption("Masai");
  love.graphics.setMode(800, 600, false, false, 0) --set the window dimensions to 650 by 650

  width  = love.graphics.getWidth()
  height = love.graphics.getHeight()
  camera:setBounds(0, 0, width, height)

  fonts = {
           small  = love.graphics.newFont(12),
           medium = love.graphics.newFont(16),
           large  = love.graphics.newFont(24)
          }

  love.audio.play(sounds.music1);
end

function add(a, b, coll)
    if (a == "pad") and sounds.bounce:isStopped() then
       love.audio.play(sounds.bounce)
    end
end

function persist(a, b, coll)
    if (b == "player") and not (a == "wall") then
       player.canJump = true;
       player.canRun  = true;
    end
end

function rem(a, b, coll)
    if (b == "player") and not (a == "wall") then
       player.canJump = false;
       player.canRun  = false;
    end
end

function love.update(dt)
  if dt > 0.02 then dt = 0.02 end
  mouse:update();

  if not (gamestate.paused) then
     box2d.world:update(dt) --this puts the world into motion
     player:update(dt);
     spear:update(dt);
     camera:setPosition( player.xpos - width / 2, player.ypos - height / 2 );
  end

  if love.keyboard.isDown( "escape" ) then
      love.event.push('q');
  end
  if love.keyboard.isDown( "f12" ) then
     if not (gamestate.fullscreen) then
         love.graphics.setMode(1440, 900, true, false, 0) --set the window dimensions to 1440 by 900
         gamestate.fullscreen = true;
         width = love.graphics.getWidth()
         height = love.graphics.getHeight()
         camera:setBounds(0, 0, width, height)
     else
         love.graphics.setMode(800, 600, false, false, 0) --set the window dimensions to 650 by 650
         gamestate.fullscreen = false;
         width = love.graphics.getWidth()
         height = love.graphics.getHeight()
         camera:setBounds(0, 0, width, height)
     end
  end

 if not (gamestate.paused) then
  --here we are going to create some keyboard events
  if love.keyboard.isDown("d") then --press the d key to push the player to the right
    player:moveRight();
    player.moving  = true;
    player.running = 1;
  elseif love.keyboard.isDown("a") then --press the a key to push the player to the left
    player:moveLeft();
    player.moving  = true;
    player.running = -1;
  else
    player.moving  = false;
  end
   
 end -- end not (gamestate.paused)
end

function love.keypressed(key, unicode)
  if key == " " and player.canJump and not gamestate.paused then
        player:jump();
  elseif key == "p" then
       gamestate.paused = not gamestate.paused;
  elseif key == "]" then
       gamestate.showFPS = not gamestate.showFPS;
  end    
end

function love.mousepressed(x, y, button)
	if button == "l" and not spear.jab and not spear.throw and not gamestate.paused then
        spear:jab_attack();
    end
	if button == "r" and not spear.throw and not spear.jab and not gamestate.paused then
        spear:throw_attack();
    end
end

function love.draw()

  camera:set()

  level:draw();

  player:draw();
  spear:draw();
  level:drawfg();
  
  love.graphics.setColor(250, 250, 250) --set the drawing color to white for the text

  -- love.graphics.draw(textures.cursor, mouse.xpos, mouse.ypos)

  camera:unset()

  if (gamestate.showFPS) then
     love.graphics.print("FPS: " .. love.timer.getFPS(), width - 80, 15)
  end

  if (gamestate.paused) then
     love.graphics.setFont(fonts.large);
     love.graphics.print("PAUSED", love.graphics.getWidth()/2 - 60, love.graphics.getHeight()/2 - 30 )
     love.graphics.setFont(fonts.small);
  end
  love.graphics.draw(textures.cursor, love.mouse.getX(), love.mouse.getY())
end

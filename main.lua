-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- main.lua

require 'secs'      -- a LUA OO implementation by bartbes. http://love2d.org/wiki/SECS

require 'gamestate' -- variables for things like paused / menu etc.
require 'mouse'     -- mouse distance / angle functions
require 'sounds'    -- load all our audio here
require 'textures'  -- load all our textures here

require 'level'     -- the world which holds all classes below
require 'player'    -- the player  class and associated functions
require 'spear'     -- the spear   class and associated functions



function love.load()

  gamestate:init();
  mouse:init();
  sounds:load();
  textures:load();

  level:init(650, 650, 500);
  player:init(100, 500); ---------------------------------------------
  spear:init();
require 'objects'   -- the objects class and associated functions
 
  ground = platform:new(650/2, 625, 650, 50);

  wall_left  = wall:new(5,   300, 10, 600);
  wall_right = wall:new(645, 300, 10, 600);

  plat1 = platform:new(250, 500, 180, 32);
  plat2 = platform:new(365, 350, 300, 32);
  plat3 = platform:new(55,  425,  90, 32);

  pad1  = pad:new(550, 595, 50, 10);

  box1  = box:new(300, 200, 32, 32);
  box2  = box:new(300, 160, 32, 32);
  box3  = box:new(300, 120, 32, 32);

  --initial graphics setup
  love.graphics.setCaption("Masai");
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  love.graphics.setMode(650, 650, false, true, 0) --set the window dimensions to 650 by 650

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

  mouse:update();

  if not (gamestate.paused) then
     level.world:update(dt) --this puts the world into motion
     player:update(dt);
     spear:update(dt);
  end

  if love.keyboard.isDown( "escape" ) then
      love.event.push('q');
  end
  if love.keyboard.isDown( "f12" ) then
     if not (gamestate.fullscreen) then
         love.graphics.setMode(1440, 900, true, true, 0) --set the window dimensions to 1440 by 900
         gamestate.fullscreen = true;
     else
         love.graphics.setMode(650, 650, false, true, 0) --set the window dimensions to 650 by 650
         gamestate.fullscreen = false;
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
  love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", ground.shape:getPoints()) -- draw a "filled in" polygon using the ground's coordinates

  love.graphics.setColor(172, 72, 72) -- set the drawing color to red for the walls
  love.graphics.polygon("fill", wall_left.shape:getPoints()) -- draw a "filled in" polygon using the wall's coordinates
  love.graphics.polygon("fill", wall_right.shape:getPoints()) -- draw a "filled in" polygon using the wall's coordinates

  love.graphics.setColor(150, 150, 150) -- set the drawing color to grey for the platforms

  love.graphics.polygon("fill", plat1.shape:getPoints());
  love.graphics.polygon("fill", plat2.shape:getPoints());
  love.graphics.polygon("fill", plat3.shape:getPoints());

  love.graphics.setColor(72, 60, 220) -- set the drawing color to blue for the pad
  love.graphics.polygon("fill", pad1.shape:getPoints())

  love.graphics.setColor(250, 250, 250) --set the drawing color to white for the images

  love.graphics.draw(textures.crate, box1.body:getX(), box1.body:getY(), box1.body:getAngle(), 1, 1, 16, 16);
  love.graphics.draw(textures.crate, box2.body:getX(), box2.body:getY(), box2.body:getAngle(), 1, 1, 16, 16);
  love.graphics.draw(textures.crate, box3.body:getX(), box3.body:getY(), box3.body:getAngle(), 1, 1, 16, 16);

  player:draw();
  spear:draw();

  love.graphics.setColor(250, 250, 250) --set the drawing color to white for the text

  --love.graphics.print("FPS: " .. love.timer.getFPS(), 580, 15)

  if (gamestate.paused) then
     love.graphics.setFont(24);
     love.graphics.print("PAUSED", 300, 310)
     love.graphics.setFont(12);
  end

  love.graphics.draw(textures.cursor, mouse.xpos, mouse.ypos)
end

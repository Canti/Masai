-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- main.lua

require 'secs'      -- a LUA OO implementation by bartbes. http://love2d.org/wiki/SECS

require 'gamestate' -- variables for things like paused / menu etc.
require 'mouse'     -- mouse distance / angle functions
require 'sounds'    -- load all our audio here
require 'textures'  -- load all our textures here

require 'player'    -- the player class and associated functions
require 'spear'     -- the spear class and associated functions

function love.load()

  gamestate:init();
  mouse:init();
  sounds:load();
  textures:load();

  world = love.physics.newWorld(-650, -650, 650, 650) --create a world for the bodies to exist in with width and height of 650
  world:setGravity(0, 500) --the x component of the gravity will be 0, and the y component of the gravity will be 500
  world:setMeter(64) --the height of a meter in this world will be 64px
  world:setCallbacks(add, persist, rem, result)

  player:init(100, 500); ---------------------------------------------
  spear:init();

  objects = {} -- table to hold all our physical objects
 
  --let's create the ground
  objects.ground = {}
  --we need to give the ground a mass of zero so that the ground wont move
  objects.ground.body  = love.physics.newBody(world, 650/2, 625, 0, 0) --remember, the body anchors from the center of the shape
  objects.ground.shape = love.physics.newRectangleShape(objects.ground.body, 0, 0, 650, 50, 0) --anchor the shape to the body, and make it a width of 650 and a height of 50
  objects.ground.shape:setRestitution(0);
  objects.ground.shape:setCategory(2);

  objects.right_wall = {}
  objects.right_wall.body  = love.physics.newBody(world, 645, 300, 0, 0) --remember, the body anchors from the center of the shape
  objects.right_wall.shape = love.physics.newRectangleShape(objects.right_wall.body, 0, 0, 10, 600, 0) --anchor the shape to the body, and make it a width of 10 and a height of 600
  objects.right_wall.shape:setData("wall");
  objects.right_wall.shape:setCategory(2);

  objects.left_wall = {}
  objects.left_wall.body  = love.physics.newBody(world, 5, 300, 0, 0) --remember, the body anchors from the center of the shape
  objects.left_wall.shape = love.physics.newRectangleShape(objects.left_wall.body, 0, 0, 10, 600, 0) --anchor the shape to the body, and make it a width of 10 and a height of 600
  objects.left_wall.shape:setData("wall");
  objects.left_wall.shape:setCategory(2);

  objects.plat1 = {}
  objects.plat1.body  = love.physics.newBody(world, 250, 500, 0, 0) --remember, the body anchors from the center of the shape
  objects.plat1.shape = love.physics.newRectangleShape(objects.plat1.body, 0, 0, 180, 30, 0) --anchor the shape to the body, and make it a width of 180 and a height of 30
  objects.plat1.shape:setRestitution(0);
  objects.plat1.shape:setCategory(2);

  objects.plat2 = {}
  objects.plat2.body  = love.physics.newBody(world, 365, 350, 0, 0) --remember, the body anchors from the center of the shape
  objects.plat2.shape = love.physics.newRectangleShape(objects.plat2.body, 0, 0, 300, 30, 0) --anchor the shape to the body, and make it a width of 300 and a height of 30
  objects.plat2.shape:setRestitution(0);
  objects.plat2.shape:setCategory(2);

  objects.plat3 = {}
  objects.plat3.body  = love.physics.newBody(world, 55, 425, 0, 0) --remember, the body anchors from the center of the shape
  objects.plat3.shape = love.physics.newRectangleShape(objects.plat3.body, 0, 0, 90, 30, 0) --anchor the shape to the body, and make it a width of 90 and a height of 30
  objects.plat3.shape:setRestitution(0);
  objects.plat3.shape:setCategory(2);

  objects.pad = {}
  objects.pad.body = love.physics.newBody(world, 550, 595, 0, 0) --remember, the body anchors from the center of the shape
  objects.pad.shape = love.physics.newRectangleShape(objects.pad.body, 0, 0, 50, 10, 0) --anchor the shape to the body, and make it a width of 50 and a height of 10
  objects.pad.shape:setRestitution(2);
  objects.pad.shape:setData("pad");
  objects.pad.shape:setCategory(2);
 
  --let's create a box
  objects.box = {}
  objects.box.body  = love.physics.newBody(world, 300, 200, 1, 0)
  objects.box.shape = love.physics.newRectangleShape(objects.box.body, 0, 0, 32, 32, 0)
  objects.box.body:setMassFromShapes();
  objects.box.shape:setRestitution(0);
  objects.box.shape:setCategory(2);


  --initial graphics setup
  love.graphics.setCaption("Masai");
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  love.graphics.setMode(650, 650, false, true, 0) --set the window dimensions to 650 by 650

  love.audio.play(sounds.music);
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
     world:update(dt) --this puts the world into motion
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
  love.graphics.polygon("fill", objects.ground.shape:getPoints()) -- draw a "filled in" polygon using the ground's coordinates

  love.graphics.setColor(172, 72, 72) -- set the drawing color to red for the walls
  love.graphics.polygon("fill", objects.left_wall.shape:getPoints()) -- draw a "filled in" polygon using the wall's coordinates
  love.graphics.polygon("fill", objects.right_wall.shape:getPoints()) -- draw a "filled in" polygon using the wall's coordinates

  love.graphics.setColor(150, 150, 150) -- set the drawing color to grey for the platforms
  love.graphics.polygon("fill", objects.plat1.shape:getPoints()) -- draw a "filled in" polygon using the platforms's coordinates
  love.graphics.polygon("fill", objects.plat2.shape:getPoints()) -- draw a "filled in" polygon using the platforms's coordinates
  love.graphics.polygon("fill", objects.plat3.shape:getPoints()) -- draw a "filled in" polygon using the platforms's coordinates

  love.graphics.setColor(72, 60, 220) -- set the drawing color to blue for the pad
  love.graphics.polygon("fill", objects.pad.shape:getPoints()) -- draw a "filled in" polygon using the pad's coordinates

  love.graphics.setColor(250, 250, 250) --set the drawing color to white for the images

    love.graphics.draw(textures.crate, objects.box.body:getX(), objects.box.body:getY(), objects.box.body:getAngle(), 1, 1, 16, 16);

    love.graphics.draw(textures.masai_torso, player.xpos, (player.ypos - 20), 0, player.facing, 1,  10, player.torso_ypos);
    love.graphics.draw(textures.masai_head,  player.xpos, (player.ypos - 25), 0, player.facing, 1,   0, player.torso_ypos);
    love.graphics.draw(textures.masai_hand,  player.xpos, (player.ypos - 12), 0, player.facing, 1, -10, 0);
    love.graphics.draw(textures.masai_hand,  player.xpos, (player.ypos - 25), 0, player.facing, 1,  15, 0);

    love.graphics.draw(textures.masai_foot,  player.xpos, player.ypos, 0, player.running, 1,  3 + player.foot1_xpos, -8 + player.foot1_ypos);
    love.graphics.draw(textures.masai_foot,  player.xpos, player.ypos, 0, player.running, 1,  3 + player.foot2_xpos, -8 + player.foot2_ypos);

  love.graphics.draw(textures.spear, spear.xpos, spear.ypos, spear.angle,  1, 1,  35, 5);

  love.graphics.setColor(250, 250, 250) --set the drawing color to white for the text

  --love.graphics.print("FPS: " .. love.timer.getFPS(), 580, 15)

  if (gamestate.paused) then
     love.graphics.setFont(24);
     love.graphics.print("PAUSED", 300, 310)
     love.graphics.setFont(12);
  end

  love.graphics.draw(textures.cursor, mouse.xpos, mouse.ypos)
end

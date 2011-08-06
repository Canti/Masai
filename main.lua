local paused = false;
local fullscreen = false;

local canJump = false;
local canRun  = false;

local spear_speed = 100;
local x_spear_tip = 0;
local y_spear_tip = 0;

local jab     = false;
local jabtime = 0;

local throw     = false;
local throwtime = 0;

local facing  = 1;
local running = 1;
angle_feet  = 0;
angle_torso = 0;
xpos_foot1 = 0; xpos_foot2 = 0;
ypos_foot1 = 0; ypos_foot2 = 0;
ypos_torso = 0;

function love.load()
  music = love.audio.newSource("music/greenochrome.xm");
  music:setLooping(true);
  music:setVolume(0.3);

  bounce_sound_1 = love.audio.newSource("sounds/drum_1.ogg");
  bounce_sound_1:setVolume(1.0);
  throw_sound_1 = love.audio.newSource("sounds/woosh_1.ogg");
  throw_sound_1:setVolume(1.0);
  throw_sound_2 = love.audio.newSource("sounds/woosh_2.ogg");
  throw_sound_2:setVolume(1.0);

  love.mouse.setVisible(false)
  cursor      = love.graphics.newImage("textures/cursor.png");

  spear       = love.graphics.newImage("textures/spear.png");
  masai_head  = love.graphics.newImage("textures/masai_head.png");
  masai_hand  = love.graphics.newImage("textures/masai_hand.png");
  masai_torso = love.graphics.newImage("textures/masai_torso.png");
  masai_foot  = love.graphics.newImage("textures/masai_foot.png");

  crate       = love.graphics.newImage("textures/crate.png");

  love.audio.play(music)

  world = love.physics.newWorld(-650, -650, 650, 650) --create a world for the bodies to exist in with width and height of 650
  world:setGravity(0, 500) --the x component of the gravity will be 0, and the y component of the gravity will be 500
  world:setMeter(64) --the height of a meter in this world will be 64px
  world:setCallbacks(add, persist, rem, result)
 
  objects = {} -- table to hold all our physical objects
 
  --let's create the ground
  objects.ground = {}
  --we need to give the ground a mass of zero so that the ground wont move
  objects.ground.body  = love.physics.newBody(world, 650/2, 625, 0, 0) --remember, the body anchors from the center of the shape
  objects.ground.shape = love.physics.newRectangleShape(objects.ground.body, 0, 0, 650, 50, 0) --anchor the shape to the body, and make it a width of 650 and a height of 50
  objects.ground.shape:setRestitution(0);
  objects.ground.shape:setData("static");
  objects.ground.shape:setCategory(2);

  objects.right_wall = {}
  objects.right_wall.body  = love.physics.newBody(world, 645, 300, 0, 0) --remember, the body anchors from the center of the shape
  objects.right_wall.shape = love.physics.newRectangleShape(objects.right_wall.body, 0, 0, 10, 600, 0) --anchor the shape to the body, and make it a width of 650 and a height of 50
  objects.right_wall.shape:setCategory(2);

  objects.left_wall = {}
  objects.left_wall.body  = love.physics.newBody(world, 5, 300, 0, 0) --remember, the body anchors from the center of the shape
  objects.left_wall.shape = love.physics.newRectangleShape(objects.left_wall.body, 0, 0, 10, 600, 0) --anchor the shape to the body, and make it a width of 650 and a height of 50
  objects.left_wall.shape:setCategory(2);

  objects.plat1 = {}
  objects.plat1.body  = love.physics.newBody(world, 250, 500, 0, 0) --remember, the body anchors from the center of the shape
  objects.plat1.shape = love.physics.newRectangleShape(objects.plat1.body, 0, 0, 180, 30, 0) --anchor the shape to the body, and make it a width of 180 and a height of 30
  objects.plat1.shape:setRestitution(0);
  objects.plat1.shape:setData("static");
  objects.plat1.shape:setCategory(2);

  objects.plat2 = {}
  objects.plat2.body  = love.physics.newBody(world, 365, 350, 0, 0) --remember, the body anchors from the center of the shape
  objects.plat2.shape = love.physics.newRectangleShape(objects.plat2.body, 0, 0, 300, 30, 0) --anchor the shape to the body, and make it a width of 300 and a height of 30
  objects.plat2.shape:setRestitution(0);
  objects.plat2.shape:setData("static");
  objects.plat2.shape:setCategory(2);

  objects.plat3 = {}
  objects.plat3.body  = love.physics.newBody(world, 55, 425, 0, 0) --remember, the body anchors from the center of the shape
  objects.plat3.shape = love.physics.newRectangleShape(objects.plat3.body, 0, 0, 90, 30, 0) --anchor the shape to the body, and make it a width of 900 and a height of 30
  objects.plat3.shape:setRestitution(0);
  objects.plat3.shape:setData("static");
  objects.plat3.shape:setCategory(2);

  objects.pad = {}
  objects.pad.body = love.physics.newBody(world, 550, 600, 0, 0) --remember, the body anchors from the center of the shape
  objects.pad.shape = love.physics.newRectangleShape(objects.pad.body, 0, 0, 50, 10, 0) --anchor the shape to the body, and make it a width of 650 and a height of 50
  objects.pad.shape:setRestitution(2);
  objects.pad.shape:setData("pad");
  objects.pad.shape:setCategory(2);
 
  --let's create the player
  objects.player = {}
  objects.player.body = love.physics.newBody(world, 100, 500, 1, 0) --place the body in the center of the world, with a mass of 1
  objects.player.shape = love.physics.newCircleShape(objects.player.body, 0, 0, 20) --the player's shape has no offset from it's body and has a radius of 20
  objects.player.body:setAngularDamping(20.0);
  objects.player.body:setMassFromShapes();
  objects.player.shape:setRestitution(0);
  objects.player.shape:setFriction(1.0);
  objects.player.shape:setData("player");
  objects.player.shape:setCategory(1);
  objects.player.shape:setMask(1);

  --let's create the spear
  objects.spear = {}
  objects.spear.body = love.physics.newBody(world, 100, 500, 1, 0)
  objects.spear.shape = love.physics.newRectangleShape(objects.spear.body, 0, 0, 67, 8, 0)
  objects.spear.body:setAngularDamping(7.5);
  objects.spear.body:setMassFromShapes();
  objects.spear.shape:setRestitution(0);
  objects.spear.shape:setData("spear");
  objects.spear.shape:setCategory(1);
  objects.spear.shape:setMask(1);


  --let's create a box
  objects.box = {}
  objects.box.body  = love.physics.newBody(world, 300, 200, 1, 0)
  objects.box.shape = love.physics.newRectangleShape(objects.box.body, 0, 0, 30, 30, 0)
  objects.box.body:setMassFromShapes();
  objects.box.shape:setRestitution(0);
  objects.box.shape:setData("static");
  objects.box.shape:setCategory(2);


  --initial graphics setup
  love.graphics.setCaption("Masai");
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  love.graphics.setMode(650, 650, false, true, 0) --set the window dimensions to 650 by 650
end

function add(a, b, coll)
    if (a == "pad") then
       love.audio.play(bounce_sound_1)
    end
end

function persist(a, b, coll)
    if (b == "player") and (a == "static") then
       canJump = true;
       canRun  = true;
    end
end

function rem(a, b, coll)
    if (b == "player") and (a == "static") then
       canJump = false;
       canRun  = false;
    end
end

function love.update(dt)
  if not (paused) then
     world:update(dt) --this puts the world into motion
  end

  if throw then
     throwtime = throwtime + dt;
  end
  if throwtime > 1.0 then
     throwtime = 0;
     throw = false;
  end

  if jab then
     jabtime = jabtime + dt;
  end
  if jabtime > 0.075 then
     jabtime = 0;
     jab = false;
  end

  xvel, yvel = objects.player.body:getLinearVelocity()

  xvel_spear, yvel_spear = objects.spear.body:getLinearVelocity()

  mouse_x, mouse_y = love.mouse.getPosition();
  x_distance  =  mouse_x - objects.spear.body:getX();
  y_distance  =  mouse_y - objects.spear.body:getY();
  mouse_angle = (math.atan2(y_distance, x_distance));

  angle_torso = angle_torso%math.pi + dt;
  ypos_torso  = math.sin(4*angle_torso);

  if (mouse_x > objects.player.body:getX()) then
     facing = 1;
  elseif (mouse_x < objects.player.body:getX()) then
     facing = -1;
  end

  if jab or throw then
      if xvel_spear > spear_speed then
         objects.spear.body:setLinearVelocity(spear_speed, yvel_spear);
      elseif xvel_spear < -spear_speed then
         objects.spear.body:setLinearVelocity(-spear_speed, yvel_spear);
      end
      if yvel_spear > spear_speed then
         objects.spear.body:setLinearVelocity(xvel_spear, spear_speed);
      elseif yvel_spear < -spear_speed then
         objects.spear.body:setLinearVelocity(xvel_spear, -spear_speed);
      end
  end
   

  -- limit x velocity
  if xvel > 800 then
     objects.player.body:setLinearVelocity(800, yvel);
  elseif xvel < -800 then
     objects.player.body:setLinearVelocity(-800, yvel);
  end

  -- limit y velocity
  if yvel > 800 then
     objects.player.body:setLinearVelocity(xvel, 800);
  elseif yvel < -800 then
     objects.player.body:setLinearVelocity(xvel, -800);
  end

  if love.keyboard.isDown( "escape" ) then
      love.event.push('q');
  end
  if love.keyboard.isDown( "f12" ) then
     if not (fullscreen) then
         love.graphics.setMode(1440, 900, true, true, 0) --set the window dimensions to 650 by 650
         fullscreen = true;
     else
         love.graphics.setMode(650, 650, false, true, 0) --set the window dimensions to 650 by 650
         fullscreen = false;
     end
  end

  if not (paused) then
  --here we are going to create some keyboard events
  if love.keyboard.isDown("d") then --press the d key to push the player to the right
       if xvel < 220 and canRun then
          objects.player.body:applyForce(8, 0)
       elseif xvel < 220 then
          objects.player.body:applyForce(3, 0)
       end
    angle_feet = angle_feet%math.pi + dt;
    -- <TechnoCat> A*sin(B*x)+C A=amplitude, 1/B = frequency, C=y-offset
    xpos_foot1, ypos_foot1 = math.cos(12*angle_feet)*10, math.sin(12*angle_feet)*4;
    xpos_foot2, ypos_foot2 = math.cos(12*angle_feet+10)*10, math.sin(12*angle_feet+10)*4;

    running = 1;
  elseif love.keyboard.isDown("a") then --press the a key to push the player to the left
       if xvel > -220 and canRun then
          objects.player.body:applyForce(-8, 0)
       elseif xvel > -220 then
          objects.player.body:applyForce(-3, 0)
       end
    angle_feet = angle_feet%math.pi + dt;
    xpos_foot1, ypos_foot1 = math.cos(12*angle_feet)*10, math.sin(12*angle_feet)*4;
    xpos_foot2, ypos_foot2 = math.cos(12*angle_feet+10)*10, math.sin(12*angle_feet+10)*4;

    running = -1;
  else
    xpos_foot1, ypos_foot1 =  5, -4;
    xpos_foot2, ypos_foot2 = -5, -4;
  end
  end -- end not (paused)
end

function love.keypressed(key, unicode)
  if key == " " and canJump and not paused then
       objects.player.body:applyImpulse(0, -2.3, 10, 10)
  elseif key == "p" then
       paused = not paused;
  end    
end

function love.mousepressed(x, y, button)
--    x_spear_tip = (objects.spear.body:getX() + math.cos(mouse_angle)*33);
--    y_spear_tip = (objects.spear.body:getY() + math.cos(mouse_angle)*33);
    objects.spear.body:setAngularVelocity(0);
    x_spear_tip = (objects.spear.body:getX() + 33.5*math.cos(mouse_angle));
    y_spear_tip = (objects.spear.body:getY() + 33.5*math.sin(mouse_angle));
	-- Checks which button was pressed.
	if button == "l" and not jab and not throw and not paused then
       jab = true; spear_speed = 500;
       objects.spear.body:applyImpulse( (x - objects.spear.body:getX())/100, (y - objects.spear.body:getY())/100, x_spear_tip, y_spear_tip );
       love.audio.play(throw_sound_2);
    end
	if button == "r" and not throw and not jab and not paused then
       throw = true; spear_speed = 500;
       objects.spear.body:applyImpulse( (x - objects.spear.body:getX())/50,  (y - objects.spear.body:getY())/50,  x_spear_tip, y_spear_tip );
       love.audio.play(throw_sound_1);
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

    love.graphics.draw(crate, objects.box.body:getX(), objects.box.body:getY(), objects.box.body:getAngle(), 1, 1, 15, 15);

    love.graphics.draw(masai_torso, objects.player.body:getX(), (objects.player.body:getY() - 20), 0, facing, 1,  10, ypos_torso);
    love.graphics.draw(masai_head,  objects.player.body:getX(), (objects.player.body:getY() - 25), 0, facing, 1,   0, ypos_torso);
    love.graphics.draw(masai_hand,  objects.player.body:getX(), (objects.player.body:getY() - 12), 0, facing, 1, -10, 0);
    love.graphics.draw(masai_hand,  objects.player.body:getX(), (objects.player.body:getY() - 25), 0, facing, 1,  15, 0);

    love.graphics.draw(masai_foot,  objects.player.body:getX(), (objects.player.body:getY()), 0, running, 1,  3 + xpos_foot1, -8 + ypos_foot1);
    love.graphics.draw(masai_foot,  objects.player.body:getX(), (objects.player.body:getY()), 0, running, 1,  3 + xpos_foot2, -8 + ypos_foot2);

   if not throw and not jab then
       objects.spear.body:setAngle(mouse_angle);
       objects.spear.body:setX(objects.player.body:getX() - (11 * facing));
       objects.spear.body:setY(objects.player.body:getY() - 23);
   end

  love.graphics.draw(spear, objects.spear.body:getX(), (objects.spear.body:getY()), objects.spear.body:getAngle(),  1, 1,  35, 5);

  love.graphics.setColor(250, 250, 250) --set the drawing color to white for the text

  love.graphics.print("FPS: " .. love.timer.getFPS(), 580, 15)

  love.graphics.print("Mass: " .. objects.player.body:getMass(), 580, 35)

  if (paused) then
     love.graphics.setFont(24);
     love.graphics.print("PAUSED", 300, 310)
     love.graphics.setFont(12);
  end

  love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
end

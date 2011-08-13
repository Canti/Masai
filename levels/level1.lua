  -- love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  love.graphics.setBackgroundColor(41, 126, 222) --set the background color to a nice blue
  box2d:init(1440, 900, 500); -- x, y, gravity
  require '../objects'   -- the objects class and associated functions
  require 'levels/scenery'
  
  scenery:init(800)
  
  player:init(120, 100);
  spear:init();
 
  ground = platform:new(1300/2, 825, 1300, 50);

  wall_left  = wall:new(5,    400, 10, 800);
  wall_right = wall:new(1295, 400, 10, 800);

  plat1 = platform:new(250, 700, 180, 32);
  plat2 = platform:new(365, 550, 300, 32);
  plat3 = platform:new(55,  625,  90, 32);

  pad1  = pad:new(550, 795, 50, 10);

  box1  = box:new(300, 200, 32, 32);
  box2  = box:new(300, 160, 32, 32);
  box3  = box:new(300, 120, 32, 32);

  -- plat4 = platform:new(700,  550, 32, 32); -- new
  -- plat5 = platform:new(1000, 550, 32, 32); -- new
  plat4 = platform:new(700,  550, 20, 10); -- needs to be the same size as the bridge elements, otherwise the bridge will be connected at a weird place
  plat5 = platform:new(1000, 500, 20, 10); -- needs to be the same size as the bridge elements, otherwise the bridge will be connected at a weird place

  -- numLinks x linkWidth should equal the distance between the two points the bridge is connected to
  -- the two points should have equal y values, too, but that shouldn't break it like it does...
  numLinks = 15; linkWidth = 20;
  chainPieces = {}
  makeChain(plat4, plat5, chainPieces, numLinks, linkWidth);

level = class:new()

function level:draw()

  scenery:drawbg()
  love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", ground.shape:getPoints()) -- draw a "filled in" polygon using the ground's coordinates

  love.graphics.setColor(172, 72, 72) -- set the drawing color to red for the walls
  love.graphics.polygon("fill", wall_left.shape:getPoints()) -- draw a "filled in" polygon using the wall's coordinates
  love.graphics.polygon("fill", wall_right.shape:getPoints()) -- draw a "filled in" polygon using the wall's coordinates

  love.graphics.setColor(150, 150, 150) -- set the drawing color to grey for the platforms

  love.graphics.polygon("fill", plat1.shape:getPoints());
  love.graphics.polygon("fill", plat2.shape:getPoints());
  love.graphics.polygon("fill", plat3.shape:getPoints());

  love.graphics.polygon("fill", plat4.shape:getPoints());
  love.graphics.polygon("fill", plat5.shape:getPoints());

	love.graphics.setColor(255, 255, 255)
	for i=1, numLinks do
		x1, y1 = chainPieces[i].shape:getPoints( )
		love.graphics.draw(textures.wood_block, x1, y1, chainPieces[i].body:getAngle(), 20/32, 10/16, 0,0);
        -- love.graphics.draw(textures.wood_block, chainPieces[i].body:getX(), chainPieces[i].body:getY(), chainPieces[i].body:getAngle(), 20/32, 10/16, 10, 5);
		--love.graphics.draw(textures.wood_block, chainPieces[i].body:getX(), chainPieces[i].body:getY(), chainPieces[i].body:getAngle(), 20/32, 10/16, 10, 5);
		--love.graphics.polygon("fill", chainPieces[i].shape:getPoints())
	end

  love.graphics.setColor(72, 60, 220) -- set the drawing color to blue for the pad
  love.graphics.polygon("fill", pad1.shape:getPoints())

  love.graphics.setColor(250, 250, 250) --set the drawing color to white for the images

  love.graphics.draw(textures.crate, box1.body:getX(), box1.body:getY(), box1.body:getAngle(), 1, 1, 16, 16);
  love.graphics.draw(textures.crate, box2.body:getX(), box2.body:getY(), box2.body:getAngle(), 1, 1, 16, 16);
  love.graphics.draw(textures.metal_crate, box3.body:getX(), box3.body:getY(), box3.body:getAngle(), 1, 1, 16, 16);



  love.graphics.setColor(255, 255, 255, 255) -- solid again  
end

function level:drawfg()
	scenery:drawfg()
end

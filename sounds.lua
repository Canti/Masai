-- Masai is a 2D platform game based on Masai folklore.
-- It uses the LÖVE 2D game engine. http://love2d.org

-- by Cantide aka Kanchi aka Karl Wortmann ( karlwortmann@gmail.com )



-- sounds.lua

sounds = class:new()  -- sounds master class


function sounds:load()

    -- create a music table in future, when i have more tracks

    self.music1 = love.audio.newSource("music/greenochrome.xm");
    self.music1:setLooping(true);
    self.music1:setVolume(0.4);

    -- a sound for the jump pads
    self.bounce = love.audio.newSource("sounds/drum_1.ogg", "static");
    self.bounce:setVolume(1.0);
    self.bounce:setPitch(0.75);

    -- throw player's spear
    self.throw = love.audio.newSource("sounds/woosh_1.ogg", "static");
    self.throw:setVolume(1.0);

    -- jab with player's spear
    self.jab = love.audio.newSource("sounds/woosh_2.ogg", "static");
    self.jab:setVolume(1.0);

end

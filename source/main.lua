import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"


local gfx <const> = playdate.graphics
local bar = {
    height = 200,
    pos = 80,
    vel = 0,
    areaHeight = 40,
    fishPos = 100,
    fishVel = 40,
    gravity = 0.5,
    accel = 1.2,
    getAccel = function ()
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            return 1
        end
        return 0
    end
}

local yvel = 0
local fp = playdate.sound.fileplayer.new()
fp:load("sounds/S2A Sky Chase")
fp:play(0)


local barSlice = gfx.nineSlice.new("images/bar0.png", 3, 3, 3, 3)
local controllableSlice = gfx.nineSlice.new("images/bar1.png", 3, 3, 3, 3)
local barWidth<const> = 24


myGameSetUp()

function playdate.update()



end
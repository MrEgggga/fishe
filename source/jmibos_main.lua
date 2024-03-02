import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/nineslice"


local fp = playdate.sound.fileplayer.new()
fp:load("sounds/S2A Sky Chase")
fp:play(0)


local gfx <const> = playdate.graphics
local bar = {
    x = 200,
    y = 20,
    height = 200,
    pos = 80,
    vel = 0,
    areaHeight = 40,
    fishPos = 100,
    fishVel = 0,
    fishGravity = 0.25,
    fishAccelMin = -8,
    fishAccelMax = 4,
    gravity = 0.5,
    accel = 1.2,
    getAccel = function ()
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            return 1
        end
        return 0
    end
}


local backgroundSprite = gfx.image.new("images/background.png")
local fishSprite = gfx.image.new("images/fish.png")
local barSlice = gfx.nineSlice.new("images/FishMeter 9Slice.png", 8, 8, 8, 8)
local controllableSlice = gfx.nineSlice.new("images/FishBar 9Slice.png", 8, 8, 8, 8)
local barWidth<const> = 24
local fishSize<const> = 14


math.randomseed(playdate.getSecondsSinceEpoch())


function playdate.update()
    backgroundSprite:draw(0, 0)

    barSlice:drawInRect(bar.x - barWidth/2, bar.y, barWidth, bar.height)
    controllableSlice:drawInRect(bar.x - barWidth/2, bar.y + bar.pos, barWidth, bar.areaHeight)
    fishSprite:draw(bar.x - fishSize / 2, bar.y + bar.fishPos - fishSize / 2)

    bar.pos += bar.vel
    bar.vel += bar.gravity
    bar.vel -= bar.accel * bar.getAccel()

    if bar.pos < 0 then
        bar.pos = 0
        bar.vel = 0
    end

    if bar.pos + bar.areaHeight > bar.height then
        bar.pos = bar.height - bar.areaHeight
        bar.vel = 0
    end

    bar.fishPos += bar.fishVel
    bar.fishVel += bar.fishGravity
    local accel = math.max(
        math.random() * (bar.fishAccelMax - bar.fishAccelMin) + bar.fishAccelMin,
        0
    )
    if bar.fishPos < 50 or bar.fishVel < -7 then
        accel = 0
    end
    if bar.fishPos > bar.height - 30 or bar.fishVel > 20 then
        accel = bar.fishAccelMax
    end
    print(accel)
    bar.fishVel -= accel
end
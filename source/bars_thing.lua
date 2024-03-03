import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/nineslice"

local gfx <const> = playdate.graphics


class("fishingMinigame")
class("barThing").extends("fishingMinigame")

function barThing:new()
    self.x = 200
    self.y = 20
    self.height = 200
    self.pos = 80
    self.vel = 0
    self.areaHeight = 40
    self.fishPos = 100
    self.fishVel = 0
    self.fishGravity = 0.25
    self.fishAccelMin = -8
    self.fishAccelMax = 4
    self.gravity = 0.5
    self.accel = 1.2
    self.getAccel = function ()
        if playdate.buttonIsPressed(playdate.kButtonUp) then
            return 1
        end
        return 0
    end
end

local backgroundSprite = gfx.image.new("images/background.png")
local fishSprite = gfx.image.new("images/fish.png")
local barSlice = gfx.nineSlice.new("images/FishMeter 9Slice.png", 3, 3, 5, 12)
local controllableSlice = gfx.nineSlice.new("images/FishBar 9Slice.png", 8, 8, 8, 8)
local barWidth <const> = 24
local fishSize <const> = 14


math.randomseed(playdate.getSecondsSinceEpoch())


function barThing:update()
    backgroundSprite:draw(0, 0)

    barSlice:drawInRect(self.x - barWidth/2, self.y, barWidth + 10, self.height)
    controllableSlice:drawInRect(self.x - barWidth/2, self.y + self.pos, barWidth, self.areaHeight)
    fishSprite:draw(self.x - fishSize / 2, self.y + self.fishPos - fishSize / 2)

    self.pos += self.vel
    self.vel += self.gravity
    self.vel -= self.accel * self.getAccel()

    if self.pos < 0 then
        self.pos = 0
        self.vel = 0
    end

    if self.pos + self.areaHeight > self.height then
        self.pos = self.height - self.areaHeight
        self.vel = 0
    end

    self.fishPos += self.fishVel
    self.fishVel += self.fishGravity
    local accel = math.max(
        math.random() * (self.fishAccelMax - self.fishAccelMin) + self.fishAccelMin,
        0
    )
    if self.fishPos < 50 or self.fishVel < -7 then
        accel = 0
    end
    if self.fishPos > self.height - 30 or self.fishVel > 20 then
        accel = self.fishAccelMax
    end
    print(accel)
    self.fishVel -= accel
end
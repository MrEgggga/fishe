import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/nineslice"

local gfx <const> = playdate.graphics
local barWidth <const> = 20
local fishSize <const> = 14


class("fishingMinigame").extends(gfx.sprite)

fishingMinigame.kIncomplete = 0
fishingMinigame.kFailure = 1
fishingMinigame.kSuccess = 2

class("barThing").extends(fishingMinigame)

function barThing:init()
    barThing.super.init(self)

    self.height = 200
    self.pos = 80
    self.vel = 0
    self.areaHeight = 40
    self.fishPos = 100
    self.fishVel = 0
    self.fishAccelMin = -1
    self.fishAccelMax = 1
    self.gravity = 0.3
    self.accel = 0.8
    self.completion = self.height / 2
    self.key = playdate.kButtonA
    self.getAccel = function (self)
        if playdate.buttonIsPressed(self.key) then
            return self.accel
        end
        return 0
    end
    self:setSize(barWidth + 10, self.height + 4)
end

local backgroundSprite = gfx.image.new("images/background.png")
local fishSprite = gfx.image.new("images/fish.png")
local barSlice = gfx.nineSlice.new("images/FishingMeter 9Slice.png", 3, 3, 5, 12)
local controllableSlice = gfx.nineSlice.new("images/FishBar 9Slice.png", 8, 8, 8, 8)


math.randomseed(playdate.getSecondsSinceEpoch())


function barThing:draw(x, y, w, h)
    barSlice:drawInRect(0, 0, barWidth + 10, self.height)
    controllableSlice:drawInRect(0, self.pos, barWidth, self.areaHeight)
    fishSprite:draw(barWidth / 2 - fishSize / 2, self.fishPos - fishSize / 2)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(barWidth + 2, self.height - self.completion, 6, self.completion)
end


function barThing:update()
    self.pos += self.vel
    self.vel += self.gravity
    self.vel -= self.accel * self:getAccel()

    if self.pos < 0 then
        self.pos = 0
        self.vel = 0
    end

    if self.pos + self.areaHeight > self.height then
        self.pos = self.height - self.areaHeight
        self.vel = 0
    end

    if self.fishPos > self.pos and self.fishPos < self.pos + self.areaHeight then
        self.completion += 1
    else
        self.completion -= 0.5
    end

    self.fishPos += self.fishVel
    
    local accelBalance = math.random()
    accelBalance -= self.fishVel / 30.0
    accelBalance -= ((self.fishPos - self.height / 2) / self.height * 2) ^ 3 / 2
    accelBalance = math.max(0, math.min(accelBalance, 1))

    self.fishVel += (self.fishAccelMax - self.fishAccelMin) * accelBalance + self.fishAccelMin
    self:markDirty()
end

function barThing:checkDone()
    if self.completion < 0 then
        return fishingMinigame.kFailure
    elseif self.completion > self.height then
        return fishingMinigame.kSuccess
    end
    return fishingMinigame.kIncomplete
end
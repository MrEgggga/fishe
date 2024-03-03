import "bars_thing"

class("barsManager").extends()

local keys <const> = {playdate.kButtonUp, playdate.kButtonB, playdate.kButtonA, playdate.kButtonRight}

barsManager.kIncomplete = 0
barsManager.kSuccess = 2
barsManager.kFailure = 1

function barsManager:init(fish_caught, reduce_bar_drain, area_size)
    self.currentBars = {}
    self.numBars = math.min(math.ceil((fish_caught+1) / 5), 4)
    self.added = 1
    self.complete = 0
    self.strikes = 0
    self.frameCounter = 0
    self.areaSize = area_size
    self.barDrain = 1 - reduce_bar_drain * 0.2
    self.frames = {math.random(0, 150)}
    for i=1,self.numBars-1 do
        table.insert(self.frames, self.frames[i] + math.random(0, 90))
    end
end

function barsManager:update()
    for i,bar in pairs(self.currentBars) do
        if bar:checkDone() ~= fishingMinigame.kIncomplete then
            bar:remove()
            table.remove(self.currentBars, i)
            self.complete += 1
            if bar:checkDone() == fishingMinigame.kFailure then
                self.strikes += 1
            end
        end
    end
    if self.strikes > self.numBars / 5 then
        for i,bar in pairs(self.currentBars) do
            bar:remove()
        end
        return barsManager.kFailure
    end
    if self.complete == self.numBars then
        return barsManager.kSuccess
    end
    if self.added <= self.numBars and self.frameCounter == self.frames[self.added] then
        local bar = barThing(self.barDrain, self.areaSize)
        table.insert(self.currentBars, bar)
        bar:moveTo(36 * self.added, 120)
        bar.key = keys[self.added]
        bar:add()
        self.added += 1
    end
    self.frameCounter += 1
    return barsManager.kIncomplete
end
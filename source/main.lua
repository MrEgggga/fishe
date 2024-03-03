import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "bars_thing.lua"
local gfx <const> = playdate.graphics

ScrollX = -200
ScrollY = -120
xvel = 0
yvel = 0

local bars = {}

function GfxSetup()
    local mapImage = gfx.image.new("Images/map")
    assert( mapImage )

    mapSprite = gfx.sprite.new( mapImage )
    mapSprite:moveTo( 200, 120 )
    mapSprite:add()

    local bar = barThing()
    local bar2 = barThing()
    bar.key = playdate.kButtonA
    bar2.key = playdate.kButtonUp
    bars = {bar, bar2}
    printTable(bar)
    bar:moveTo(220, 120)
    bar:add()
    bar2:moveTo(180, 120)
    bar2:add()
end


function playdate.update()
    if playdate.buttonIsPressed( playdate.kButtonUp ) then
        yvel-=2
    end
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        xvel+=2
    end
    if playdate.buttonIsPressed( playdate.kButtonDown ) then
        yvel+=2
    end
    if playdate.buttonIsPressed( playdate.kButtonLeft ) then
        xvel-=2
    end

    ScrollX += xvel
    ScrollY += yvel

    xvel*=0.7
	yvel*=0.7

    mapSprite:moveTo( 0-math.floor(0.5+(ScrollX/2))*2, 0-math.floor(0.5+(ScrollY/2))*2 )
    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.sprite.update()
    playdate.timer.updateTimers()

    for _,b in pairs(bars) do
        if b:checkDone() ~= fishingMinigame.kIncomplete then
            b:remove()
        end
    end
end

GfxSetup()
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/animation"
import "bars_thing.lua"
local gfx <const> = playdate.graphics

ScrollX = -200
ScrollY = -120
xvel = 0
yvel = 0
direction = "D"

local bars = {}

function GfxSetup()
    local mapImage = gfx.image.new("Images/map")
    assert( mapImage )
    local waterImage = gfx.image.new("Images/watermap")
    assert( waterImage )
    local playerImgs = gfx.imagetable.new("Images/Player")
    assert( playerImgs )
    local playerhbImg = gfx.image.new("Images/PlayerHitbox")
    assert( playerhbImg )

    wmapSprite = gfx.sprite.new( waterImage )
    wmapSprite:moveTo( 200, 120 )
    wmapSprite:add()

    PlayerHitbox = gfx.sprite.new( playerhbImg )
    PlayerHitbox:moveTo( 200,125 )
    PlayerHitbox:add()

    mapSprite = gfx.sprite.new( mapImage )
    mapSprite:moveTo( 200, 120 )
    mapSprite:add()

    local bar = barThing()
    local bar2 = barThing()
    bar.key = playdate.kButtonA
    bar2.key = playdate.kButtonB
    bars = {bar, bar2}
    printTable(bar)
    bar:moveTo(260, 120)
    bar:add()
    bar2:moveTo(160, 120)
    bar2:add()

    walkD = gfx.animation.loop.new(100, playerImgs, true)
    walkD.startFrame = 17
    walkD.endFrame = 20
    walkU = gfx.animation.loop.new(100, playerImgs, true)
    walkU.startFrame = 21
    walkU.endFrame = 24
    walkR = gfx.animation.loop.new(100, playerImgs, true)
    walkR.startFrame = 13
    walkR.endFrame = 16
    walkL = gfx.animation.loop.new(100, playerImgs, true)
    walkL.startFrame = 9
    walkL.endFrame = 12

end

GfxSetup()

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
    wmapSprite:moveTo( 0-math.floor(0.5+(ScrollX/2))*2, 0-math.floor(0.5+(ScrollY/2))*2 )
    if gfx.checkAlphaCollision(gfx.image.new("Images/PlayerHitbox"), 200-40, 125-40, gfx.kImageUnflipped, gfx.image.new("Images/watermap"), wmapSprite.x-960/2, wmapSprite.y-944/2, gfx.kImageUnflipped) then
        ScrollX -= xvel
        xvel = 0
    end

    ScrollY += yvel
    wmapSprite:moveTo( 0-math.floor(0.5+(ScrollX/2))*2, 0-math.floor(0.5+(ScrollY/2))*2 )
    if gfx.checkAlphaCollision(gfx.image.new("Images/PlayerHitbox"), 200-40, 125-40, gfx.kImageUnflipped, gfx.image.new("Images/watermap"), wmapSprite.x-960/2, wmapSprite.y-944/2, gfx.kImageUnflipped) then
        ScrollY -= yvel
        yvel = 0
    end
    mapSprite:moveTo( 0-math.floor(0.5+(ScrollX/2))*2, 0-math.floor(0.5+(ScrollY/2))*2 )
    

    xvel*=0.7
	yvel*=0.7
    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.sprite.update()

    if math.abs(xvel)+math.abs(yvel)>0.1 then
        if xvel > 0 then
            direction = "R"
        end
        if xvel < 0 then
            direction = "L"
        end
        if yvel > 0 and math.abs(yvel) > math.abs(xvel) then
            direction = "D"
        end
        if yvel < 0 and math.abs(yvel) > math.abs(xvel) then
            direction = "U"
        end
    end


    if direction == "U" then
        walkU:draw(160,80)
        walkU.delay = 500/(0.001+(math.abs(xvel)+math.abs(yvel)))
    end
    if direction == "D" then
        walkD:draw(160,80)
        walkD.delay = 500/(0.001+(math.abs(xvel)+math.abs(yvel)))
    end
    if direction == "L" then
        walkL:draw(160,80)
        walkL.delay = 500/(0.001+(math.abs(xvel)+math.abs(yvel)))
    end
    if direction == "R" then
        walkR:draw(160,80)
        walkR.delay = 500/(0.001+(math.abs(xvel)+math.abs(yvel)))
    end
    if math.abs(xvel)+math.abs(yvel)<0.1 then
        walkU.frame=1
        walkD.frame=1
        walkL.frame=1
        walkR.frame=1
    end
    

    playdate.timer.updateTimers()

    for _,b in pairs(bars) do
        if b:checkDone() ~= fishingMinigame.kIncomplete then
            b:remove()
        end
    end
end
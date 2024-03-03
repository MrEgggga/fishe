import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/animation"
local gfx <const> = playdate.graphics

ScrollX = -200
ScrollY = -120
xvel = 0
yvel = 0

function GfxSetup()
    local mapImage = gfx.image.new("Images/map")
    assert( mapImage )
    local playerImgs = gfx.imagetable.new("Images/Player")
    assert( playerImgs )

    mapSprite = gfx.sprite.new( mapImage )
    mapSprite:moveTo( 200, 120 )
    mapSprite:add()

    walkD = gfx.animation.loop.new(1, playerImgs, true)
    --set start and end frames for animation!!

    --PlayerSprite = gfx.sprite.new( mapImage )
    --PlayerSprite:moveTo( 64, 64 )
    --PlayerSprite:add()

    

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
    ScrollY += yvel

    xvel*=0.7
	yvel*=0.7

    mapSprite:moveTo( 0-math.floor(0.5+(ScrollX/2))*2, 0-math.floor(0.5+(ScrollY/2))*2 )
    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.sprite.update()
    walkD:draw(160,80)
    playdate.timer.updateTimers()
end
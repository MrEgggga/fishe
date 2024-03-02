import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
local gfx <const> = playdate.graphics

function GfxSetup()
    local mapImage = gfx.image.new("Images/map")
    assert( mapImage )

    mapSprite = gfx.sprite.new( mapImage )
    mapSprite:moveTo( 200, 120 )
    mapSprite:add()

    local backgroundImage = gfx.image.new( "Images/background" )
    assert( backgroundImage )

    gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
            backgroundImage:draw( 0, 0 )
        end
    )

end

function playdate.update()

    gfx.sprite.update()
    playdate.timer.updateTimers()
end
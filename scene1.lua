local composer = require( "composer" )
local scene = composer.newScene()

local ret = {}
local text = {}
local largura = 70
local altura = 70

local function showScene2()
    composer.gotoScene( "scene2", { effect="fade", time=200, params=customParams } )
end

function scene:create( event )
 
    local sceneGroup = self.view
       
    ret[55] = display.newImageRect(sceneGroup,"img/fundoo.png", 370,600)
    ret[55].x = 170
    ret[55].y = 220

    local logo = display.newImageRect(sceneGroup,"img/logo.png", 270,158)
    logo.x = 170
    logo.y = 170

    local function readFile()
        local path = system.pathForFile( "record.txt")
    
        local file, errorString = io.open( path, "r" )
        
        if not file then
            print( "File error: " .. errorString )
        else
            local contents = file:read( "*a" )
            text[11] = contents
            print( "Contents of " .. path .. "\n" .. contents )
            io.close( file )
        end
        file = nil
    end
    readFile()
    text[3] = display.newText(sceneGroup,"Recorde:   ", 155,  300, native.systemFontBold, 16)
    text[4] = display.newText(sceneGroup,text[11], 200,  300, native.systemFontBold, 20)
    text[4]:setFillColor(255,255,0)
    
    ret[11] = display.newImageRect(sceneGroup,"img/btnStart.png", 130,70)
    ret[11].x = 165
    ret[11].y = 400
    ret[11]:addEventListener("tap", showScene2)

 
end


-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
    
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
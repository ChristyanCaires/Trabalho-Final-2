local composer = require( "composer" )

local scene = composer.newScene()

math.randomseed(os.time())
local text = {}
local w = display.contentWidth
local h = display.contentHeight
local vX = 170
local vY = 50
local obstaculoTime1 = 0
local obstaculoTime2 = 0
local sangueTime = 0
local sangueOffTime = 0
local phy = require("physics")


local path = system.pathForFile( "record.txt", system.DocumentsDirectory )
local file, errorString = io.open( path )
phy.start()
 
local function showScene1()
    composer.gotoScene("scene1")
end

function scene:create( event )

    local sceneGroup = self.view
    local quad = {}
    local player = 0
    local obstaculo = 0
    local nivel = 0

    text[10] = 3
    text[11] = 0
    -- FUNDO
    quad[55] = display.newImageRect(sceneGroup,"img/fundoo.png", 370,600)
    quad[55].x = 170
    quad[55].y = 220

    local function trocaCenario()
        if(text[11] > 50) then
            quad[55] = display.newImageRect(sceneGroup,"img/fundo2.png", 370,600)

            quad[55].x = 170
            quad[55].y = 220

            quad[2]:toFront()
            quad[3]:toFront()
            quad[4]:toFront()
            quad[777]:toFront()
            player:toFront()
            for i=1, 4 do 
                text[i]:toFront()
            end
        end
    end

    -- SHEET PERSONAGEM
    local sheetData = {
        width = 54, 
        height = 52, 
        numFrames = 10 
    }

    local sheetDataShu = {
        width = 61, 
        height = 59, 
        numFrames = 3 
    }

    local sheetDataExp = {
        width = 106, 
        height = 89, 
        numFrames = 12 
    }
    
    local sheet = graphics.newImageSheet("img/personageem.png", sheetData)
    local sheetShu = graphics.newImageSheet("img/shuriken1.png", sheetDataShu)
    local sheetExp = graphics.newImageSheet("img/explosion.png", sheetDataExp)
    local sequenceData = {
        {name = "paradoBaixo", start = 1, count = 5, time = 500, loopCount = 1},
        {name = "moveEsquerda", start = 11, count = 5, time = 500, loopCount = 0},
        {name = "moveDireita", start = 6, count = 5, time = 500, loopCount = 0},
    }
    local sequenceDataShu = {
        {name = "shuriken", start = 1, count = 3, time = 100, loopCount = 0},
    }
    local sequenceDataExp = {
        {name = "explosion", start = 1, count = 12, time = 200, loopCount = 1},
    }

    -- textos
    text[1] = display.newText(sceneGroup,"vidas: ", 250 -200,  10, native.systemFontBold, 17)
    text[2] = display.newText(sceneGroup,"x"..text[10], 295 -200,  10, native.systemFontBold, 20)
    text[2]:setFillColor(255,0,0)
    text[3] = display.newText(sceneGroup,"pontos: ", 250,  10, native.systemFontBold, 17)
    text[4] = display.newText(sceneGroup,text[11], 295,  10, native.systemFontBold, 20)
    text[4]:setFillColor(255,255,0)

    --PERSONAGEM
    player = display.newSprite(sceneGroup,sheet, sequenceData)
    player.x = 160
    player.y = 440
    player.myName = "personagem"
    player:setSequence("paradoBaixo")
    
    -- DESENHANDO Obstaculo
    local function desenhaObstaculo()
        if(text[11] >= 0 and text[11] <= 20) then
            obstaculo = display.newImageRect(sceneGroup,"img/faca.png", 20,90)
        end
        nivel = math.random(1,3)
        if(text[11] > 20) then
            if(nivel == 1) then
                obstaculo = display.newImageRect(sceneGroup,"img/faca.png", 20,90)
            elseif(nivel == 2) then
                obstaculo = display.newSprite(sceneGroup, sheetShu, sequenceDataShu)
                obstaculo:setSequence("shuriken")
                obstaculo:play()
            elseif(nivel == 3) then
                obstaculo = display.newImageRect(sceneGroup,"img/bomb.png", 170*.4,170*.4)
            end
        end
        local mX = math.random(0,315)
        obstaculo.anchorX = 0
        obstaculo.anchorY = 0
        obstaculo.x = mX
        obstaculo.y = -150
        obstaculo.myName = "obstaculo"
        phy.addBody(obstaculo,"dynamic")
        return obstaculo
    end
    desenhaObstaculo()

    -- CHÃO 
    quad[7] = display.newImageRect(sceneGroup,"img/chao.png", 1000,20)
    quad[7].x = 160
    quad[7].y = 490
    quad[7].myName = "chao"

    -- INICIAL JUMPFLOOR
    local function jumpFloor(vax, vay)
        quad[777] = display.newImageRect(sceneGroup,"img/jumpFloor.png", 105*.55,25*.55)
        quad[777].x = vax
        quad[777].y = vay
        quad[777].myName = "jumpFloor"
        phy.addBody(quad[777],"static", { bounce=0.0, friction=0.3 })
    end
    jumpFloor(160, 450)

    local function randomGen() 
        local gen = math.random(1,3)
        local genX = 0;
        if(gen == 1) then
            genX = 50;
        elseif(gen == 2) then
            genX = 150
        else
            genX = 270
        end
        return genX
    end

    local function genFloor()
        transition.to( quad[777], { time=700, x=randomGen()})
    end

    -- FISICA
    phy.setGravity(0,9)
    phy.addBody(obstaculo, "dynamic")
    phy.addBody(quad[7], "static")
    phy.addBody(player, "dynamic", {density=1.0, bounce=0.0})
    phy.addBody(quad[777], "static")
    
    --BOTÕES
    quad[2] = display.newImageRect(sceneGroup,"img/seta.png", 70,70)
    quad[2].myName = "direita"
    quad[2].x = 120 + vX
    quad[2].y = 430 - vY
    quad[2]:toFront()
    
    quad[3] = display.newImageRect(sceneGroup,"img/seta.png", 70,70)
    quad[3].myName = "esquerda"
    quad[3].x = 40 + vX
    quad[3].y = 430 - vY
    quad[3].rotation = 180
    quad[3]:toFront()

    quad[4] = display.newImageRect(sceneGroup,"img/seta.png", 70,70)
    quad[4].myName = "cima"
    quad[4].x = 80 + vX
    quad[4].y = 390 - vY
    quad[4].rotation = -90
    quad[4]:toFront()

    quad[5] = display.newImageRect(sceneGroup,"img/sangue.png", 320,480)
    quad[5].x = 170
    quad[5].y = 220
    quad[5].isVisible = false
    quad[5]:toFront()
    local function sangue()
        quad[5].isVisible = true
        quad[5]:toFront()
    end
    local function sangueOff()
        quad[5].isVisible = false
        quad[5]:toFront()
    end
    
    --SALVANDO RECORDS
    local function writeFile(pontos)
        path = system.pathForFile( "record.txt" )
        file, errorString = io.open( path, "w" )
        
        if not file then
            print( "File error: " .. errorString )
        else
            file:write( pontos )
            io.close( file )
        end   
        file = nil
    end

    --LENDO RECORDS
    local function readFile()
        local path = system.pathForFile( "record.txt")
    
        local file, errorString = io.open( path, "r" )
        
        if not file then
            print( "File error: " .. errorString )
        else
            local contents = file:read( "*a" )
            text[22] = contents
            --print( "Contents of " .. path .. "\n" .. contents )
            io.close( file )
        end
        file = nil
        return text[22]
    end
    local passosX = 0
    local passosY = 0
    
    local function moverTap(e)
        if e.phase == "began" or e.phase == "moved" then
            if e.target.myName == "direita" then
                passosX =  3
                player:setSequence("moveDireita")
                player:play()
            elseif e.target.myName == "esquerda" then
                passosX = -3
                player:setSequence("moveEsquerda")
                player:play()
            elseif e.target.myName == "cima" then
                passosY = -3
            elseif e.target.myName == "baixo" then
                passosY =  3
            end
        elseif e.phase == "ended" then
            passosX = 0
            passosY = 0
            if e.target.myName == "direita" then
                player:setSequence("paradoBaixo")
                player:play()
            elseif e.target.myName == "esquerda" then
                player:setSequence("paradoBaixo")
                player:play()
            end
        end
    end

    --######################################## VERIFICA JOGO ###############################
    quad[8] = display.newImageRect(sceneGroup,"img/restart.png", 90,90)
    quad[8].x = 170
    quad[8].y = 290
    quad[8].isVisible = false
    quad[8]:toFront()

    local function restartGame()
        quad[8].isVisible = false

        --RESTART PERSONAGEM
        player.isVisible = true
        player.x = 160
        player.y = 430
        player.rotation = 360
        --RESTART JUMPFLOOR
        quad[777].isVisible = true
        quad[777].x = 160
        quad[777].y = 450

        --RESTART POINTS AND LIFE
         text[10] = 3
         text[2].text =  "x"..text[10]
         text[11] = 0
         text[4].text = text[11]

        --RESTART GRAVITY
         phy.setGravity(0,9)
    end
    local function zerar()
        quad[8].isVisible = true
        player.isVisible = false
        quad[777].isVisible = false
        obstaculo.isVisible = false

    end
    local function verificaVidas(items)
        if(text[10] <= 0) then
            if(tonumber( readFile() ) < tonumber(text[4].text)) then
                writeFile(text[4].text)
                zerar()
            end
            zerar()
        end
    end
    --######################################## FIM VERIFICA JOGO ###############################

    local function colisao(e)
        --detecta colisao 
        if(e.phase == "began" and e.object1.myName == "obstaculo" and e.object2.myName == "personagem") then
            obstaculo:removeSelf()
            obstaculoTime1 = timer.performWithDelay(500, desenhaObstaculo, 1)
            verificaVidas()
            if(nivel == 3) then
                local exp = display.newSprite(sceneGroup, sheetExp, sequenceDataExp)
                exp.x = player.x
                exp.y = player.y
                exp:setSequence("explosion")
                exp:play()
            end
            text[10] = text[10] - 1
            text[2].text =  "x"..text[10]
            sangueTime = timer.performWithDelay(0, sangue, 1)
            sangueOffTime = timer.performWithDelay(1000, sangueOff, 1)
        end
        if(e.phase == "began" and e.object1.myName == "obstaculo" and e.object2.myName == "chao" 
        or e.phase == "began" and e.object1.myName == "obstaculo" and e.object2.myName == "jumpFloor") then
            player:setSequence("paradobaixo")
            player:play()
            text[11] = text[11] + 5
            text[4].text = text[11]
            genFloor()
            obstaculo:removeSelf()
            obstaculoTime2 = timer.performWithDelay(500, desenhaObstaculo, 1)
            print("ainda ta colidindo")
            trocaCenario()
        end

        if(e.phase == "began" and e.object1.myName == "chao" and e.object2.myName == "personagem") then
            player:setSequence("paradobaixo")
            player:play()
            text[10] = 0
            text[2].text = text[10]
            if(tonumber( readFile() ) < tonumber(text[4].text)) then
                writeFile(text[4].text)
            end
            verificaVidas()
        end
    end


    local function update(e)
        player.x = player.x + passosX
        player.y = player.y + passosY

        if(player.x < 40) then
            player.x = 40  
        elseif (player.x > 280) then
            player.x = 280
        end
        
        if(player.y < 0) then
            player.y = 0
        elseif (player.y > 470) then
            player.y = 470
        end
    end

    quad[2]:addEventListener("touch", moverTap)
    quad[3]:addEventListener("touch", moverTap)
    quad[4]:addEventListener("touch", moverTap)
    quad[8]:addEventListener("tap", restartGame)
    Runtime:addEventListener("enterFrame", update)
    Runtime:addEventListener("collision", colisao)
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
        composer.removeScene("scene2")
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
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene

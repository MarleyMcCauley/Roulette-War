function love.load()
    backgroundImage = love.graphics.newImage('images/casiontable.png')

    images = {}
    for nameIndex, name in ipairs({
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
        'pip_heart', 'pip_diamond', 'pip_club', 'pip_spade',
        'mini_heart', 'mini_diamond', 'mini_club', 'mini_spade',
        'card', 'card_face_down',
        'face_jack', 'face_queen', 'face_king','face_goat',
    }) do
        images[name] = love.graphics.newImage('images/'..name..'.png')
    end

    
    deck = {}
    for suitIndex, suit in ipairs({'club', 'diamond','heart', 'spade'}) do
        for rank = 1, 13 do
            table.insert(deck, {suit = suit, rank = rank})
            print('suit: '..suit..', rank: '..rank)
        end
    end

    function takeCard(hand)
        table.insert(hand, table.remove(deck, love.math.random(#deck)))
    end

    RouletteHand = {}
    takeCard(RouletteHand)
    takeCard(RouletteHand)
    
    playerHand ={}
    takeCard(playerHand)
    takeCard(playerHand)
    
    dealerHand = {}
    takeCard(dealerHand)
    takeCard(dealerHand)
    
    roundOver = false

    print('Player hand:')
    for cardIndex, card in ipairs(playerHand) do
        print('suit: '..card.suit..', rank: '..card.rank)
    end
    print('Total number of cards in deck: '..#deck)

end
 local buttonY = 230
    local buttonHeight = 25
    local textOffsetY = 6

    buttonQuit = {
        x = 130,
        y = buttonY,
        width = 53,
        height = buttonHeight,
        text = 'Quit',
        textOffsetX = 16,
        textOffsetY = textOffsetY,
    }

    buttonHit = {
        x = 10,
        y = buttonY,
        width = 53,
        height = buttonHeight,
        text = 'Hit!',
        textOffsetX = 16,
        textOffsetY = textOffsetY,
    }

    buttonStand = {
        x = 70,
        y = buttonY,
        width = 53,
        height = buttonHeight,
        text = 'Stand',
        textOffsetX = 8,
        textOffsetY = textOffsetY,
    }

     buttonRoulette = {
        x = 130,
        y = buttonY,
        width = 65,
        height = buttonHeight,
        text = 'Roulette',
        textOffsetX = 8,
        textOffsetY = textOffsetY,
    }

    buttonPlayAgain = {
        x = 10,
        y = buttonY,
        width = 113,
        height = buttonHeight,
        text = 'Play again',
        textOffsetX = 24,
        textOffsetY = textOffsetY,
    }

    function isMouseInButton(button)

        return love.mouse.getX() >= button.x
        and love.mouse.getX() < button.x + button.width
        and love.mouse.getY() >= button.y
        and love.mouse.getY() < button.y + button.height
    end
    function reset()
        deck = {}
        for suitIndex, suit in ipairs({'club', 'diamond', 'heart', 'spade'}) do
            for rank = 1, 13 do
                table.insert(deck, {suit = suit, rank = rank})
            end
        end


    end

    reset()

function love.mousereleased()
    if not roundOver then
        if isMouseInButton(buttonHit) then
            takeCard(playerHand)
            if getTotal(playerHand) >= 21 then
                roundOver = true
            end
        elseif not roundOver then 
            if isMouseInButton(buttonRoulette) then 
                takeCard(RouletteHand)
                if getTotal(playerHand) >= 21 then
                roundOver = true
            end
        end
        if isMouseInButton(buttonStand) then
            roundOver = true
        end
    end
        if roundOver then
            while getTotal(dealerHand) < 17 do
                takeCard(dealerHand)
            end
        end
    elseif isMouseInButton(buttonPlayAgain) then
        love.load()
    elseif isMouseInButton(buttonQuit) then 
        love.event.quit(0)
    end
end

function love.draw()
    function getTotal(hand)
        local total = 0
        local hasAce = false

        for cardIndex, card in ipairs(hand) do
            if card.rank > 10 then
                total = total + 10
            else
            total = total + card.rank
        end

        if card.rank == 1 then
            hasAce = true
        end

        if hasAce and total <= 11 then
            total = total + 10
        end
    end
        return total
    end

    love.graphics.draw(backgroundImage, 0, 0, 0, 2, 1.7)

    local function drawCard(card, x, y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.card, x, y)

        if card.suit == 'heart' or card.suit == 'diamond' then
            love.graphics.setColor(.89, .06, .39)
        else
            love.graphics.setColor(.2, .2, .2)
        end
        
        local cardWidth = 53
        local cardHeight = 73
        
        local function drawCorner(image, OffsetX, OffsetY)
        love.graphics.draw(
            image,
            x + OffsetX,
            y + OffsetY
        )
        love.graphics.draw(
            image,
            x + cardWidth - OffsetX,
            y + cardHeight - OffsetY,
            0,
            -1
        )
    end

    drawCorner(images[card.rank], 3, 4)
    drawCorner(images['mini_'..card.suit], 3, 14)

    if card.rank > 10 then
            local faceImage
            
            if card.rank == 11 then
                faceImage = images.face_jack
            elseif card.rank == 12 then
                faceImage = images.face_queen
            elseif card.rank == 13 then
                faceImage = images.face_king
            end
            
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(faceImage, x + 12, y + 11)
        else
            local function drawPip(offsetX, offsetY, mirrorX, mirrorY)
            local pipImage = images['pip_'..card.suit]
            local pipWidth = 11

            love.graphics.draw(
                    pipImage,
                    x + offsetX,
                    y + offsetY
                )
             if mirrorX then
                    love.graphics.draw(
                        pipImage,
                        x + cardWidth - offsetX - pipWidth,
                        y + offsetY
                    )
                end
                if mirrorY then
                    love.graphics.draw(
                        pipImage,
                        x + offsetX + pipWidth,
                        y + cardHeight - offsetY,
                        0,
                        -1
                    )
                end
                if mirrorX and mirrorY then
                    love.graphics.draw(
                        pipImage,
                        x + cardWidth - offsetX,
                        y + cardHeight - offsetY,
                        0,
                        -1
                    )
                end
            end

            local xLeft = 11
            local xMid = 21
            local yTop = 7
            local yThird = 19
            local yQtr = 23
            local yMid = 31
            
              if card.rank == 1 then
                drawPip(xMid, yMid)

            elseif card.rank == 2 then
                drawPip(xMid, yTop, false, true)

            elseif card.rank == 3 then
                drawPip(xMid, yTop, false, true)
                drawPip(xMid, yMid)

            elseif card.rank == 4 then
                drawPip(xLeft, yTop, true, true)
            
            elseif card.rank == 5 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xMid, yMid)

            elseif card.rank == 6 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yMid, true)

            elseif card.rank == 7 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yMid, true)
                drawPip(xMid, yThird)

            elseif card.rank == 8 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yMid, true)
                drawPip(xMid, yThird, false, true)

            elseif card.rank == 9 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yQtr, true, true)
                drawPip(xMid, yMid)

            elseif card.rank == 10 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yQtr, true, true)
                drawPip(xMid, 16, false, true)
            end
        end
end

local cardSpacing = 60
local marginX = 10

for cardIndex, card in ipairs(dealerHand) do 
    local dealerMarginY = 30
    if not roundOver and cardIndex == 1 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
    else
    drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
end
end
for cardIndex, card in ipairs(playerHand) do
        drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
end
love.graphics.setColor(3, 5, 3)

    if roundOver then
        love.graphics.print('Total: '..getTotal(dealerHand), marginX, 10)
    else
        love.graphics.print('Total: ?', marginX, 10)
    end

    love.graphics.print('Total: '..getTotal(playerHand), marginX, 120)

     if roundOver then
        local function hasHandWon(thisHand, otherHand)
            return getTotal(thisHand) <= 21
            and (
                getTotal(otherHand) > 21
                or getTotal(thisHand) > getTotal(otherHand)
            )
        end

        local function drawWinner(message)
            love.graphics.print(message, marginX, 268)
        end

        if hasHandWon(playerHand, dealerHand) then
            drawWinner('Hero achieves victory over the evil Dealer')
        elseif hasHandWon(dealerHand, playerHand) then
            drawWinner('Dealer has defeated the noble Hero')
        else
            drawWinner('The battle has come to a stalemate')
        end
    end
    
    local function drawButton(button)

        if isMouseInButton(button) then
            love.graphics.setColor(1, .8, .3)
        else
            love.graphics.setColor(1, .5, .2)
        end
        love.graphics.rectangle('fill', button.x, button.y, button.width, button.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(button.text, button.x + button.textOffsetX, button.y + button.textOffsetY)
    end
if not roundOver then
    drawButton(buttonHit)
    drawButton(buttonStand)
    drawButton(buttonRoulette)
else
    drawButton(buttonPlayAgain)
    drawButton(buttonQuit)
end
end 


-- Pong Game - Part 1

local WINDOW_WIDTH = 800
local WINDOW_HEIGHT = 600

-- Left Paddle
local player1 = {
    x = 30,
    y = 250,
    width = 15,
    height = 100,
    speed = 300
}

-- Right Paddle
local player2 = {
    x = 755,
    y = 250,
    width = 15,
    height = 100,
    speed = 300
}

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle("Pong Game")

    love.graphics.setBackgroundColor(0.1, 0.1, 0.12)
end

function love.update(dt)

    -- Player 1: W and S
    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed * dt
    end

    if love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed * dt
    end

    -- Player 2: Up and Down
    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed * dt
    end

    if love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed * dt
    end

    -- Keep paddles inside the window
    player1.y = math.max(0,
        math.min(player1.y, WINDOW_HEIGHT - player1.height))

    player2.y = math.max(0,
        math.min(player2.y, WINDOW_HEIGHT - player2.height))
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    -- Draw Left Paddle
    love.graphics.rectangle(
        "fill",
        player1.x,
        player1.y,
        player1.width,
        player1.height
    )

    -- Draw Right Paddle
    love.graphics.rectangle(
        "fill",
        player2.x,
        player2.y,
        player2.width,
        player2.height
    )
end

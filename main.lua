-- Pong Game with Extra Features

local WINDOW_WIDTH = 800
local WINDOW_HEIGHT = 600
local WINNING_SCORE = 5

-- Players
local player1 = {
    x = 30,
    y = 250,
    width = 15,
    height = 100,
    speed = 300,
    score = 0
}

local player2 = {
    x = 755,
    y = 250,
    width = 15,
    height = 100,
    speed = 300,
    score = 0
}

-- Ball
local ball = {
    x = 390,
    y = 290,
    width = 20,
    height = 20,
    dx = 250,
    dy = 180
}

local paused = false
local winner = nil

-- AABB collision detection
local function checkCollision(a, b)
    return a.x < b.x + b.width
        and a.x + a.width > b.x
        and a.y < b.y + b.height
        and a.y + a.height > b.y
end

-- Reset ball after a point
local function resetBall()
    ball.x = (WINDOW_WIDTH - ball.width) / 2
    ball.y = (WINDOW_HEIGHT - ball.height) / 2

    ball.dx = love.math.random(0, 1) == 0
        and -250 or 250

    ball.dy = love.math.random(0, 1) == 0
        and -180 or 180
end

-- Start a new match
local function restartGame()
    player1.score = 0
    player2.score = 0

    player1.y = 250
    player2.y = 250

    paused = false
    winner = nil

    resetBall()
end

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle("Pong Game")

    love.graphics.setBackgroundColor(0.1, 0.1, 0.12)

    resetBall()
end

function love.update(dt)
    -- Stop updates when paused or game is over
    if paused or winner then
        return
    end

    -- Move player 1
    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed * dt
    end

    if love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed * dt
    end

    -- Move player 2
    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed * dt
    end

    if love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed * dt
    end

    -- Keep paddles inside screen
    player1.y = math.max(
        0,
        math.min(player1.y, WINDOW_HEIGHT - player1.height)
    )

    player2.y = math.max(
        0,
        math.min(player2.y, WINDOW_HEIGHT - player2.height)
    )

    -- Move ball using dt
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Top wall collision
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end

    -- Bottom wall collision
    if ball.y + ball.height >= WINDOW_HEIGHT then
        ball.y = WINDOW_HEIGHT - ball.height
        ball.dy = -ball.dy
    end

    -- Left paddle collision
    if ball.dx < 0 and checkCollision(ball, player1) then
        ball.x = player1.x + player1.width
        ball.dx = -ball.dx
    end

    -- Right paddle collision
    if ball.dx > 0 and checkCollision(ball, player2) then
        ball.x = player2.x - ball.width
        ball.dx = -ball.dx
    end

    -- Player 2 scores
    if ball.x + ball.width < 0 then
        player2.score = player2.score + 1

        if player2.score >= WINNING_SCORE then
            winner = "Player 2"
        else
            resetBall()
        end
    end

    -- Player 1 scores
    if ball.x > WINDOW_WIDTH then
        player1.score = player1.score + 1

        if player1.score >= WINNING_SCORE then
            winner = "Player 1"
        else
            resetBall()
        end
    end
end

function love.keypressed(key)
    -- Pause / Resume
    if key == "p" and not winner then
        paused = not paused
    end

    -- Restart match after winning
    if key == "r" and winner then
        restartGame()
    end

    -- Exit game
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    -- Center line
    love.graphics.setColor(0.35, 0.35, 0.4)

    for y = 0, WINDOW_HEIGHT - 1, 30 do
        love.graphics.rectangle(
            "fill",
            WINDOW_WIDTH / 2 - 2,
            y,
            4,
            15
        )
    end

    -- Player 1: Green
    love.graphics.setColor(0.3, 0.85, 0.6)

    love.graphics.rectangle(
        "fill",
        player1.x,
        player1.y,
        player1.width,
        player1.height
    )

    -- Player 2: Blue
    love.graphics.setColor(0.4, 0.65, 1)

    love.graphics.rectangle(
        "fill",
        player2.x,
        player2.y,
        player2.width,
        player2.height
    )

    -- Ball: Red
    love.graphics.setColor(1, 0, 0)

    love.graphics.rectangle(
        "fill",
        ball.x,
        ball.y,
        ball.width,
        ball.height
    )

    -- Draw scores
    love.graphics.setColor(1, 1, 1)

    love.graphics.print(
        "Player 1: " .. player1.score,
        200, 30
    )

    love.graphics.print(
        "Player 2: " .. player2.score,
        500, 30
    )

    -- Controls
    love.graphics.print(
        "W/S: Player 1   |   UP/DOWN: Player 2   |   P: Pause",
        170, 570
    )

    -- Pause screen
    if paused and not winner then
        love.graphics.setColor(0, 0, 0, 0.65)

        love.graphics.rectangle(
            "fill",
            0, 0,
            WINDOW_WIDTH,
            WINDOW_HEIGHT
        )

        love.graphics.setColor(1, 1, 1)

        love.graphics.printf(
            "PAUSED\nPress P to Resume",
            0, 260,
            WINDOW_WIDTH,
            "center"
        )
    end

    -- Winning screen
    if winner then
        love.graphics.setColor(0, 0, 0, 0.75)

        love.graphics.rectangle(
            "fill",
            0, 0,
            WINDOW_WIDTH,
            WINDOW_HEIGHT
        )

        love.graphics.setColor(1, 1, 1)

        love.graphics.printf(
            winner .. " WINS!\nPress R to Restart",
            0, 260,
            WINDOW_WIDTH,
            "center"
        )
    end
end

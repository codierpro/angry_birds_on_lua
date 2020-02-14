VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

push = require 'push'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('static')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- new Box2D "world" which will run all of our physics calculations
    world = love.physics.newWorld(0, 300)

    -- body that stores velocity and position and all fixtures
    boxBody = love.physics.newBody(world, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 'static')

    -- shape that we will attach using a fixture to our body for collision detection
    boxShape = love.physics.newRectangleShape(10, 10)

    -- fixture that attaches a shape to our body
    boxFixture = love.physics.newFixture(boxBody, boxShape)
end

function push.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    
    -- update world, calculating collisions
    world:update(dt)
end

function love.draw()
    push:start()
    
    -- draw a polygon shape by getting the world points for our body, using the box shape's
    -- definition as a reference
    love.graphics.polygon('fill', boxBody:getWorldPoints(boxShape:getPoints()))

    push:finish()
end
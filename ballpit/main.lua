VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

DEGREES_TO_RADIANS = 0.0174532925199432957
RADIANS_TO_DEGREES = 57.295779513082320876

push = require 'push'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('kinematic')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    world = love.physics.newWorld(0, 300)

    groundBody = love.physics.newBody(world, 0, VIRTUAL_HEIGHT - 30, 'static')
    leftWallBody = love.physics.newBody(world, 0, 0, 'static')
    rightWallBody = love.physics.newBody(world, VIRTUAL_WIDTH, 0, 'static')

    edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH, 0)
    wallShape = love.physics.newEdgeShape(0, 0, 0, VIRTUAL_HEIGHT)

    groundFixture = love.physics.newFixture(groundBody, edgeShape)
    leftWallFixture = love.physics.newFixture(leftWallBody, wallShape)
    rightWallFixture = love.physics.newFixture(rightWallBody, wallShape)

    personBody = love.physics.newBody(world, math.random(VIRTUAL_WIDTH), 0, 'dynamic')
    personShape = love.physics.newRectangleShape(30, 30)
    personFixture = love.physics.newFixture(personBody, personShape, 20)

    dynamicBodies = {}
    dynamicFixtures = {}
    ballShape = love.physics.newCircleShape(5)

    for i = 1, 1000 do
        table.insert(dynamicBodies, {
            love.physics.newBody(world, 
                math.random(VIRTUAL_WIDTH), math.random(VIRTUAL_HEIGHT - 30), 'dynamic'),
            r = math.random(255),
            g = math.random(255),
            b = math.random(255)
        })
        table.insert(dynamicFixtures, love.physics.newFixture(dynamicBodies[i][1], ballShape))
    end
end

function push.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        personBody:setPosition(math.random(VIRTUAL_WIDTH), 0)
    end
end

function love.update(dt)
    
    world:update(dt)
end

function love.draw()
    push:start()

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.setLineWidth(2)
    love.graphics.line(groundBody:getWorldPoints(edgeShape:getPoints()))

    for i = 1, #dynamicBodies do
        love.graphics.setColor(
            dynamicBodies[i].r, dynamicBodies[i].g, dynamicBodies[i].b, 255
        )
        love.graphics.circle('fill', 
            dynamicBodies[i][1]:getX(),
            dynamicBodies[i][1]:getY(),
            ballShape:getRadius()
        )
    end

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.polygon('fill', personBody:getWorldPoints(personShape:getPoints()))

    push:finish()
end
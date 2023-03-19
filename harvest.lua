love.graphics.setDefaultFilter("nearest", "nearest")
SCALE = 4

function love.load()
    bg = love.graphics.newImage("sprites/background.png")
    uibg = love.graphics.newImage("sprites/uibg.png")
    uifg = love.graphics.newImage("sprites/uifg.png")

    cursors = {
        closed = love.mouse.newCursor("sprites/cursors/closed.png", 12, 12),
        open = love.mouse.newCursor("sprites/cursors/open.png", 12, 12),
        pointer = love.mouse.newCursor("sprites/cursors/pointer.png", 7, 1),
        click = love.mouse.newCursor("sprites/cursors/click.png", 7, 1),
        thumbdown = love.mouse.newCursor("sprites/cursors/thumbdown.png", 12, 12),
        thumbup = love.mouse.newCursor("sprites/cursors/thumbup.png", 12, 12),
    }
    love.mouse.setCursor(cursors.pointer)
    mouse = {
        x = 0,
        y = 0,
        can_grab = "",
        grab_in = nil,
        grab_object = nil,
    }

    body = require "body"

    inventory = require "inventory"

end

function love.update(dt)
    mouse.can_grab = ""
    mouse.grab_in = nil

    -- Body
    if body.is_hovered_by(mouse) then
        mouse.grab_in = body.organs  -- map
    end

    for name, organ in pairs(body.organs) do
        if organ.is_hovered_by(mouse) then
            mouse.can_grab = name
        end
    end

    -- Inventory
    if inventory.is_hovered_by(mouse) then
        mouse.grab_in = inventory.organs  -- map
    end

    for name, organ in pairs(inventory.organs) do
        if organ.is_hovered_by(mouse) then
            mouse.can_grab = name
        end
    end
end

function love.draw()
    -- Background
    love.graphics.draw(bg, 0, 0, nil, SCALE)
    love.graphics.draw(uibg, 0, 0, nil, SCALE)

    -- Body
    body.draw()

    -- Inventory
    inventory.draw()
    
    -- Organs
    for name, organ in pairs(body.organs) do
        organ.draw()
    end

    for name, organ in pairs(inventory.organs) do
        organ.draw()
    end

    if mouse.grab_object ~= nil then
        mouse.grab_object.draw()
    end

    -- UI
    love.graphics.draw(uifg, 0, 0, nil, SCALE)
end

-- Mouse
function love.mousemoved(x, y, dx, dy, istouch)
    mouse.x = x
    mouse.y = y

    if not love.mouse.isDown(1) then
        if mouse.can_grab then
            love.mouse.setCursor(cursors.open)
        else
            love.mouse.setCursor(cursors.pointer)
        end
    else
        if mouse.grab_object ~= nil then
            mouse.grab_object.x = mouse.x - SCALE * mouse.grab_object.max_x / 2
            mouse.grab_object.y = mouse.y - SCALE * mouse.grab_object.max_y / 2
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then -- primary button
        if mouse.can_grab ~= "" then
            love.mouse.setCursor(cursors.closed)

            mouse.grab_object = mouse.grab_in[mouse.can_grab]
            mouse.grab_in[mouse.can_grab] = nil

            mouse.grab_object.x = mouse.x - SCALE * mouse.grab_object.max_x / 2
            mouse.grab_object.y = mouse.y - SCALE * mouse.grab_object.max_y / 2
        else
            love.mouse.setCursor(cursors.click)
        end
    end
end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then -- primary button
        if mouse.grab_object ~= nil then
            local organ = mouse.grab_object
            if body.is_hovered_by(mouse) then
                organ.to_body(body)
            else
                organ.to_inventory(inventory)
            end
            mouse.grab_object = nil
        end

        if mouse.can_grab ~= "" then
            love.mouse.setCursor(cursors.open)

            local organ = mouse.grab_object
        else
            love.mouse.setCursor(cursors.pointer)
        end
    end
end

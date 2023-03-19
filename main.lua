love.graphics.setDefaultFilter("nearest", "nearest")
SCALE = 4

function draw_interface()
    local x = love.graphics.getWidth() / 2 - tooltip:getWidth() / 2
    local y = love.graphics.getHeight() / 2

    local survival = 0
    local total_organs = 0
    local critical_missing = false
    local profit_low = 0
    local profit_high = 0
    for _, organ in pairs(body.organs) do
        survival = survival + organ.quality
        total_organs = total_organs + 1
    end

    for _, organ in pairs(inventory.organs) do
        profit_low = profit_low + organ.price_low
        profit_high = profit_high + organ.price_high
        if organ.critical then
            critical_missing = true
        end
    end
    
    if critical_missing then
        survival = 0
    else
        survival = survival / total_organs
    end

    love.graphics.draw(tooltip, x, y)
    love.graphics.setColor(love.math.colorFromBytes(47, 46, 50))
    love.graphics.print("== Operation informations ==", x + 5, y + 5 + 0 * 16)
    love.graphics.print("Survival: " .. math.floor(100 * survival) .. "%", x + 5, y + 5 + 1 * 16)
    love.graphics.print("Profit: " .. format_int(profit_low) .. "-" .. format_int(profit_high) .. "µ", x + 5, y + 5 + 2 * 16)

    love.graphics.setColor(255, 255, 255)
end

function love.load()
    bg = love.graphics.newImage("sprites/background.png")
    uibg = love.graphics.newImage("sprites/uibg.png")
    uifg = love.graphics.newImage("sprites/uifg.png")
    tooltip = love.graphics.newImage("sprites/infos.png")

    -- Sound
    bgm = love.audio.newSource("sounds/theme-0.mp3", "stream")
    berk = {
        love.audio.newSource("sounds/berk1.wav", "static"),
        love.audio.newSource("sounds/berk2.wav", "static"),
        love.audio.newSource("sounds/berk3.wav", "static"),
        love.audio.newSource("sounds/berk4.wav", "static"),
        love.audio.newSource("sounds/berk5.wav", "static"),
        love.audio.newSource("sounds/berk6.wav", "static"),
        love.audio.newSource("sounds/berk7.wav", "static"),
    }
    tuto1 = love.audio.newSource("sounds/tutorial-1.mp3", "stream")
    tuto2 = love.audio.newSource("sounds/tutorial-2.mp3", "stream")

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

    love.audio.play(tuto1)
end

function love.update(dt)
	if not tuto1:isPlaying() and not bgm:isPlaying() then 
		love.audio.play( bgm )
	end

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

    draw_interface()
    
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
    if mouse.can_grab ~= "" then
        mouse.grab_in[mouse.can_grab].draw_infos(mouse)
    end
end

-- Mouse
function love.mousemoved(x, y, dx, dy, istouch)
    mouse.x = x
    mouse.y = y

    if love.mouse.isDown(1) then
        if mouse.grab_object ~= nil then
            mouse.grab_object.x = mouse.x - SCALE * mouse.grab_object.max_x / 2
            mouse.grab_object.y = mouse.y - SCALE * mouse.grab_object.max_y / 2
        end
    else
        if mouse.can_grab ~= "" then
            love.mouse.setCursor(cursors.open)
        else
            love.mouse.setCursor(cursors.pointer)
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

            love.audio.play(berk[love.math.random(#berk)])
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

            love.audio.play(berk[love.math.random(#berk)])
        end

        if mouse.can_grab ~= "" then
            love.mouse.setCursor(cursors.open)

            local organ = mouse.grab_object
        else
            love.mouse.setCursor(cursors.pointer)
        end
    end
end

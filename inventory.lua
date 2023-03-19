inventory = {
    x = SCALE * 212,
    y = SCALE * 24,
    sprite = love.graphics.newImage("sprites/shelf.png"),
    position = 0,
}
inventory.max_x = inventory.sprite:getWidth()
inventory.max_y = inventory.sprite:getHeight()

inventory.draw = function()
    love.graphics.draw(inventory.sprite, inventory.x, inventory.y, nil, SCALE)
end

inventory.is_hovered_by = function (target)
    local x = inventory.x
    local y = inventory.y
    local max_x = x + SCALE * inventory.max_x
    local max_y = y + SCALE * inventory.max_y

    if target.x > x and target.x < max_x and target.y > y and target.y < max_y then
        return true
    else
        return false
    end
end

inventory.organs = {}  -- empty at first

inventory.next_xy = function ()
    local x = inventory.x + SCALE * (6 + 23 * (inventory.position % 3))
    local y = inventory.y + SCALE * (5 + 26 * math.floor(inventory.position / 3))
    inventory.position = inventory.position + 1
    return x, y
end

return inventory

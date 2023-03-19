body = {
    x = SCALE * 53,
    y = SCALE * 17,
    sprite = love.graphics.newImage("sprites/body.png"),
}
body.max_x = body.sprite:getWidth()
body.max_y = body.sprite:getHeight()

body.draw = function ()
    love.graphics.draw(body.sprite, body.x, body.y, nil, SCALE)
end

body.is_hovered_by = function (target)
    local x = body.x
    local y = body.y
    local max_x = x + SCALE * body.max_x
    local max_y = y + SCALE * body.max_y

    if target.x > x and target.x < max_x and target.y > y and target.y < max_y then
        return true
    else
        return false
    end
end

body.organs = {}

organs = require "organs"

-- Init position
for _, organ in pairs(organs) do
    organ.to_body(body)
end

return body

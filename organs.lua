function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function format_int(number)

    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  
    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1'")
  
    -- reverse the int-string back remove an optional comma and put the 
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^'", "") .. fraction
  end

organs = {
    skull = {
        name = "skull",
        body_x = 2,
        body_y = 3,
        sprite = love.graphics.newImage("sprites/organs/skull.png"),
        
        base_price = 1224,
        critical = false,
    },

    brain = {
        name = "brain",
        body_x = 20,
        body_y = 4,
        sprite = love.graphics.newImage("sprites/organs/brain.png"),
        
        base_price = 151,
        critical = true,
    },

    lungs = {
        name = "lungs",
        body_x = 5,
        body_y = 24,
        sprite = love.graphics.newImage("sprites/organs/lungs.png"),
        
        base_price = 272123,
        critical = true,
    },

    heart = {
        name = "heart",
        body_x = 23,
        body_y = 24,
        sprite = love.graphics.newImage("sprites/organs/heart.png"),
        
        base_price = 119911,
        critical = true,
    },

    stomach = {
        name = "stomach",
        body_x = 12,
        body_y = 40,
        sprite = love.graphics.newImage("sprites/organs/stomach.png"),
        
        base_price = 508,
        critical = false,
    },

    kidneys = {
        name = "kidneys",
        body_x = 2,
        body_y = 57,
        sprite = love.graphics.newImage("sprites/organs/kidneys.png"),
        
        base_price = 262568,
        critical = false,
    },

    intestine = {
        name = "intestine",
        body_x = 21,
        body_y = 56,
        sprite = love.graphics.newImage("sprites/organs/intestine.png"),
        
        base_price = 2519,
        critical = false,
    },

    bone = {
        name = "bone",
        body_x = 6,
        body_y = 75,
        sprite = love.graphics.newImage("sprites/organs/bone.png"),
        
        base_price = 755,
        critical = false,
    }
}

for _, organ in pairs(organs) do
    organ.quality = math.random()  -- quality will be between 0 and 1
    organ.is_fake = false
    organ.x = -1
    organ.y = -1
    organ.max_x = organ.sprite:getWidth()
    organ.max_y = organ.sprite:getHeight()

    local price_fake = 1
    if organ.is_fake then
        price_fake = 0.66
    end
    local price = (organ.quality + 0.1) * organ.base_price * price_fake
    organ.price_low = math.floor(price * 0.88)
    organ.price_high = math.floor(price * 1.22)

    organ.is_hovered_by = function (target)
        local x = organ.x
        local y = organ.y
        local max_x = x + SCALE * organ.max_x
        local max_y = y + SCALE * organ.max_y
    
        if target.x > x and target.x < max_x and target.y > y and target.y < max_y then
            return true
        else
            return false
        end
    end

    organ.draw = function ()
        love.graphics.draw(organ.sprite, organ.x, organ.y, nil, SCALE)
    end

    organ.to_body = function (body)
        organ.x = body.x + SCALE * organ.body_x
        organ.y = body.y + SCALE * organ.body_y
        body.organs[organ.name] = organ
    end

    organ.to_inventory = function (inventory)
        local x, y = inventory.next_xy()
        organ.x = x
        organ.y = y
        inventory.organs[organ.name] = organ
    end

    organ.draw_infos = function (target)
        local x = target.x + 4
        local y = target.y + 4
        love.graphics.draw(tooltip, x, y)
        love.graphics.setColor(love.math.colorFromBytes(47, 46, 50))
        love.graphics.print("== " .. firstToUpper(organ.name) .. " ==", x + 5, y + 5 + 0 * 16)
        local fake = "No"
        if organ.is_fake then
            fake = "Yes..."
        end
        love.graphics.print("Fake: " .. fake, x + 5, y + 5 + 1 * 16)
        love.graphics.print("Quality: " .. math.floor(organ.quality * 100) .. "%", x + 5, y + 5 + 2 * 16)
        love.graphics.print("Price range: " .. format_int(organ.price_low) .. "-" .. format_int(organ.price_high) .. "µ", x + 5, y + 5 + 4 * 16)
        love.graphics.setColor(255, 255, 255)
    end
end

return organs

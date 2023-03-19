organs = {
    skull = {
        name = "skull",
        body_x = 2,
        body_y = 3,
        sprite = love.graphics.newImage("sprites/organs/skull.png"),
    },

    brain = {
        name = "brain",
        body_x = 20,
        body_y = 4,
        sprite = love.graphics.newImage("sprites/organs/brain.png"),
    },

    lungs = {
        name = "lungs",
        body_x = 5,
        body_y = 24,
        sprite = love.graphics.newImage("sprites/organs/lungs.png"),
    },

    heart = {
        name = "heart",
        body_x = 23,
        body_y = 24,
        sprite = love.graphics.newImage("sprites/organs/heart.png"),
    },

    stomach = {
        name = "stomach",
        body_x = 12,
        body_y = 40,
        sprite = love.graphics.newImage("sprites/organs/stomach.png"),
    },

    kidneys = {
        name = "kidneys",
        body_x = 2,
        body_y = 57,
        sprite = love.graphics.newImage("sprites/organs/kidneys.png"),
    },

    intestine = {
        name = "intestine",
        body_x = 21,
        body_y = 56,
        sprite = love.graphics.newImage("sprites/organs/intestine.png"),
    },

    bone = {
        name = "bone",
        body_x = 6,
        body_y = 75,
        sprite = love.graphics.newImage("sprites/organs/bone.png"),
    }
}

for _, organ in pairs(organs) do
    organ.quality = 1  -- quality will be between 0 and 1
    organ.is_fake = false
    organ.x = -1
    organ.y = -1
    organ.max_x = organ.sprite:getWidth()
    organ.max_y = organ.sprite:getHeight()

    organ.is_hovered_by = function (target)
        local x = organ.x
        local y = organ.y
        local max_x = x + SCALE * organ.max_x
        local max_y = y + SCALE * organ.max_y
    
        if target.x > x and target.x < max_x and target.y > y and target.y < max_y then
            print(organ.name)
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
end

return organs

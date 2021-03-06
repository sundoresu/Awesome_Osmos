local debugger = require('debugger')

local random = math.random

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local CELL_RADIUS_RANGE = {min=5, max=30}
local CELL_SPEED_RANGE = {min=-100, max=100}

local Cell = {}
function Cell:create(location, velocity, radius)
  local cell = display.newCircle(location.x, location.y, radius)
  cell:setFillColor( 1, 1, 1, .5 )
  cell.originalRadius = radius
  cell.velocity = velocity

  function cell:move()
    self.x = self.x + self.velocity.x
    self.y = self.y + self.velocity.y

    local wallWithCollision = self:wallWithCollision()
    self:collideWithWall(wallWithCollision)
  end

  function cell:collideWithWall(wallWithCollision)
    if wallWithCollision == 'left' then
      self.velocity.x = -self.velocity.x
    elseif wallWithCollision == 'right' then
      self.velocity.x = -self.velocity.x
    elseif wallWithCollision == 'top' then
      self.velocity.y = -self.velocity.y
    elseif wallWithCollision == 'bottom' then
      self.velocity.y = -self.velocity.y
    end
  end

  function cell:wallWithCollision()
    local radius = self:currentRadius()

    if self.x - radius < 0 then
      return 'left'
    elseif self.x + radius > _W then
      return 'right'
    elseif self.y - radius < 0 then
      return 'top'
    elseif self.y + radius > _H then
      return 'bottom'
    end
  end

  function cell:collideWithCell(otherCell)
    if self:currentRadius() >= otherCell:currentRadius() then
      local distanceBetweenCells = self:distanceToOtherCell(otherCell)

      local pixelsToGrow = -distanceBetweenCells / 2
      local pixelsToShrink = 3 * distanceBetweenCells / 2

      self:growRadiusByPixels(pixelsToGrow)
      otherCell:growRadiusByPixels(pixelsToShrink)
    end
  end

  function cell:growRadiusByPixels(pixels)
    local oldRadius = self:currentRadius()
    local newRadius = oldRadius + pixels
    print(radius)

    local scale
    if (oldRadis ~= 0) then
      scale = newRadius / oldRadius
    else
      scale = oldRadius
    end

    self:scale(scale, scale)
  end

  function cell:distanceToOtherCell(otherCell)
    local dx = self.x - otherCell.x
    local dy = self.y - otherCell.y
    local distance = math.sqrt(dx*dx + dy*dy)

    return distance - (self:currentRadius() + otherCell:currentRadius())
  end

  function cell:isCollidedWith(otherCell)
    return self:distanceToOtherCell(otherCell) <= 0
  end

  function cell:currentRadius()
    return self.xScale * self.originalRadius
  end

  return cell
end

function Cell:createRandom()
  local location = {
    x = random(0, _W),
    y = random(0, _H)
  }
  local velocity = {
    x = random(CELL_SPEED_RANGE.min, CELL_SPEED_RANGE.max)/100,
    y = random(CELL_SPEED_RANGE.min, CELL_SPEED_RANGE.max)/100
  }
  local radius = random(CELL_RADIUS_RANGE.min, CELL_RADIUS_RANGE.max)

  return Cell:create(location, velocity, radius)
end


return Cell

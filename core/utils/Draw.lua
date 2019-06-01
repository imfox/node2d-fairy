local gr = love.graphics

---@class Fairy_Core_Utils_Draw
local c = {}

---@see graphics#print
---@param text string
---@param x number
---@param y number
---@param r number
---@param sx number
---@param sy number
---@param ox number
---@param oy number
---@param kx number
---@param ky number
---@param stroke number
---@param strokeColor table
function c.print(text, x, y, r, sx, sy, ox, oy, kx, ky, stroke, strokeColor)
    if stroke > 0 then
        local r_, g, b, a = gr.getColor()
        gr.setColor(strokeColor)
        gr.print(text, x - stroke, y - stroke, r, sx, sy, ox, oy, kx, ky)
        gr.print(text, x - stroke, y, r, sx, sy, ox, oy, kx, ky)
        gr.print(text, x - stroke, y + stroke, r, sx, sy, ox, oy, kx, ky)

        gr.print(text, x + stroke, y - stroke, r, sx, sy, ox, oy, kx, ky)
        gr.print(text, x + stroke, y, r, sx, sy, ox, oy, kx, ky)
        gr.print(text, x + stroke, y + stroke, r, sx, sy, ox, oy, kx, ky)

        gr.print(text, x, y - stroke, r, sx, sy, ox, oy, kx, ky)
        gr.print(text, x, y + stroke, r, sx, sy, ox, oy, kx, ky)
        gr.setColor(r_, g, b, a)
    end
    gr.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
end

---@see graphics#printf
---@param text string
---@param x number
---@param y number
---@param limit number
---@param align AlignMode
---@param r number
---@param sx number
---@param sy number
---@param ox number
---@param oy number
---@param kx number
---@param ky number
---@param stroke number
---@param strokeColor number[]
function c.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky, stroke, strokeColor)
    if stroke and stroke > 0 then
        local r_, g, b, a = gr.getColor()
        gr.setColor(strokeColor)
        gr.printf(text, x - stroke, y - stroke, limit, align, r, sx, sy, ox, oy, kx, ky)
        gr.printf(text, x - stroke, y, limit, align, r, sx, sy, ox, oy, kx, ky)
        gr.printf(text, x - stroke, y + stroke, limit, align, r, sx, sy, ox, oy, kx, ky)

        gr.printf(text, x + stroke, y - stroke, limit, align, r, sx, sy, ox, oy, kx, ky)
        gr.printf(text, x + stroke, y, limit, align, r, sx, sy, ox, oy, kx, ky)
        gr.printf(text, x + stroke, y + stroke, limit, align, r, sx, sy, ox, oy, kx, ky)

        gr.printf(text, x, y - stroke, limit, align, r, sx, sy, ox, oy, kx, ky)
        gr.printf(text, x, y + stroke, limit, align, r, sx, sy, ox, oy, kx, ky)
        gr.setColor(r_, g, b, a)
    end
    --print(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky, stroke, strokeColor)
    gr.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
end

return c;
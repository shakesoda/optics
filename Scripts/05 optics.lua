optics = {}

function Actor:hit(mx, my)
	local width, height = self:GetZoomedWidth() / 2, self:GetZoomedHeight() / 2
	local x, y = self:GetX(), self:GetY()

	if
		mx > (x - width)  and mx < (x + width) and
		my > (y - height) and my < (y + height)
	then
		return true
	else
		return false
	end
end

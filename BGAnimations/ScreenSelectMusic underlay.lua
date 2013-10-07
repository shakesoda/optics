local frame_color = { 0, 0, 0, 0.8 }

local t = Def.ActorFrame {}

-- t[#t+1] = Def.Quad {}
-- t[#t].InitCommand=function(self)
-- 	self:setsize(5, SCREEN_HEIGHT)
-- 	self:x(SCREEN_RIGHT)
-- 	self:horizalign(left)
-- 	self:vertalign(top)
-- 	self:diffuseleftedge {0,0,0,0}
-- 	self:diffuserightedge {0.2,0.2,0.2,0.5}
-- end
-- t[#t].OnCommand=function(self)
-- 	self:decelerate(0.25)
-- 	self:x(SCREEN_RIGHT-325)
-- end
-- t[#t].OffCommand=function(self)
-- 	self:accelerate(0.25)
-- 	self:x(SCREEN_RIGHT)
-- end

t[#t+1] = Def.Quad {
	InitCommand=cmd(FullScreen;diffuse,frame_color)
}

return t
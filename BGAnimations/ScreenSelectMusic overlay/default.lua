local t = Def.ActorFrame {}
local frame_height = 30
local frame_color = { 0, 0, 0, 0.8 }

local arrow_x = SCREEN_RIGHT-295
local arrow_offset = 40

local speed = THEME:GetMetric("MusicWheel","SwitchSeconds")

local BounceBeginBezier = { 0, 0.85, 0.9, 1 }

local function compute_columns(region_width, threshold, max)
	if max == nil then max = 3 end
	local count = max
	local width = region_width
	while count > 0 do
		local width = region_width / count
		if width < threshold then
			count = count - 1
		else
			return count, width
		end
	end
end

local column_count, column_width = compute_columns(SCREEN_WIDTH-320, 256, 2)
local column_positions = {}
local column_padding = 5

for i=1,column_count do
	column_positions[i] = i*column_width - column_padding
	t[#t+1] = Def.Quad {
		InitCommand=cmd(x,column_positions[i];horizalign,left;vertalign,top;setsize,5,SCREEN_HEIGHT;diffuse,{0, 0, 0, 0.8})
	}
end

column_width = column_width - column_padding

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(setsize,320,50;xy,SCREEN_RIGHT-160,SCREEN_CENTER_Y),
	LeftClickMessageCommand=function(self)
		local mx, my = INPUTFILTER:GetMouseX(), INPUTFILTER:GetMouseY()
		if self:hit(mx, my) and GAMESTATE:GetCurrentSong() then
			local screen = SCREENMAN:GetTopScreen()
			screen:PostScreenMessage("SM_BeginFadingOut", 0)
			screen:lockinput(1)
			--screen:PostScreenMessage("SM_GoToNextScreen", 0.65)
		end
	end
}

-- banner
t[#t+1] = Def.ActorProxy {
	BeginCommand=function(self)
		local banner = SCREENMAN:GetTopScreen():GetChild('Banner')
		local factor = column_width / 256
		local size = { x = 256 * factor, y = 80 * factor }
		self:SetTarget(banner)
		banner:scaletoclipped(size.x, size.y)
		self:xy(column_positions[#column_positions] - (size.x / 2), size.y / 2)
	end
}

-- wheel highlight
t[#t+1] = Def.ActorFrame {
	PreviousSongMessageCommand=cmd(stoptweening;sleep,0.01;y,-50;tween,speed+0.2,"TweenType_Bezier",BounceBeginBezier;y,0),
	NextSongMessageCommand=cmd(stoptweening;sleep,0.01;y,50;tween,speed+0.2,"TweenType_Bezier",BounceBeginBezier;y,0),
	OffCommand=cmd(accelerate,0.25;x,320),
	Def.Quad {
		InitCommand=function(self)
			(cmd(setsize,320,10;xy,SCREEN_RIGHT,SCREEN_CENTER_Y-25))(self);
			(cmd(horizalign,right;vertalign,bottom;diffusealpha,0))(self);
			(cmd(diffuse,{0,0,0,0}))(self)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening()
			self:diffusealpha(0)
			self:sleep(0.25)
			self:linear(speed*3)
			self:diffusetopedge {0,0,0,0}
			self:diffusebottomedge {0,0,0,0.25}
		end,
	},
	Def.Quad {
		InitCommand=function(self)
			(cmd(setsize,320,10;xy,SCREEN_RIGHT,SCREEN_CENTER_Y+25))(self);
			(cmd(horizalign,right;vertalign,top;diffusealpha,0))(self);
			(cmd(diffuse,{0,0,0,0}))(self)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening()
			self:diffusealpha(0)
			self:sleep(0.25)
			self:linear(speed*3)
			self:diffusebottomedge {0,0,0,0}
			self:diffusetopedge {0,0,0,0.25}
		end,
	}
}

-- song change arrows
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,320),
	OnCommand=cmd(decelerate,0.25;x,0),
	OffCommand=cmd(accelerate,0.25;x,320),
	MouseWheelUpMessageCommand=function(self)
		local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
		mw:Move(-1) mw:Move(0)
		MESSAGEMAN:Broadcast("PreviousSong")
	end,
	MouseWheelDownMessageCommand=function(self)
		local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
		mw:Move(1) mw:Move(0)
		MESSAGEMAN:Broadcast("NextSong")
	end,
	LoadActor(THEME:GetPathG("", "_arrow"))..{
		InitCommand=cmd(xy,arrow_x,SCREEN_CENTER_Y-arrow_offset;diffusealpha,0),
		PreviousSongMessageCommand=cmd(stoptweening;zoom,1;diffusealpha,1;sleep,0.08;linear,0.2;zoom,1.45;diffusealpha,0;sleep,0.05;zoom,1),
		LeftClickMessageCommand=function(self)
			local mx, my = INPUTFILTER:GetMouseX(), INPUTFILTER:GetMouseY()

			if self:hit(mx, my) then
				self:playcommand("PreviousSong")
			end
		end
	},
	LoadActor(THEME:GetPathG("", "_arrow"))..{
		InitCommand=cmd(xy,arrow_x,SCREEN_CENTER_Y-arrow_offset;diffusealpha,0.5),
		LeftClickMessageCommand=function(self)
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			local mx, my = INPUTFILTER:GetMouseX(), INPUTFILTER:GetMouseY()

			if self:hit(mx, my) then
				mw:Move(-1) mw:Move(0)
			end
		end
	},
	LoadActor(THEME:GetPathG("", "_arrow"))..{
		InitCommand=cmd(xy,arrow_x,SCREEN_CENTER_Y+arrow_offset;rotationz,180;diffusealpha,0),
		NextSongMessageCommand=cmd(stoptweening;zoom,1;diffusealpha,1;sleep,0.08;linear,0.2;zoom,1.45;diffusealpha,0;sleep,0.05;zoom,1),
		LeftClickMessageCommand=function(self)
			local mx, my = INPUTFILTER:GetMouseX(), INPUTFILTER:GetMouseY()

			if self:hit(mx, my) then
				self:playcommand("NextSong")
			end
		end
	},
	LoadActor(THEME:GetPathG("", "_arrow"))..{
		InitCommand=cmd(xy,arrow_x,SCREEN_CENTER_Y+arrow_offset;rotationz,180;diffusealpha,0.5),
		LeftClickMessageCommand=function(self)
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			local mx, my = INPUTFILTER:GetMouseX(), INPUTFILTER:GetMouseY()

			if self:hit(mx, my) then
				mw:Move(1) mw:Move(0)
			end
		end
	}
}

-- frames
if false then
t[#t+1] = Def.Quad {}
t[#t].InitCommand=function(self)
	self:vertalign(top)
	self:horizalign(left)
	self:setsize(SCREEN_WIDTH, frame_height)
	self:diffuse(frame_color)
	self:y(-frame_height)
end
t[#t].OnCommand=cmd(decelerate,0.25;y,0)
t[#t].OffCommand=cmd(decelerate,0.25;y,-frame_height)

t[#t+1] = Def.Quad {}
t[#t].InitCommand=function(self)
	self:vertalign(bottom)
	self:horizalign(left)
	self:setsize(SCREEN_WIDTH, frame_height)
	self:diffuse(frame_color)
	self:y(SCREEN_HEIGHT+frame_height)
end
t[#t].OnCommand=cmd(decelerate,0.25;y,SCREEN_HEIGHT)
t[#t].OffCommand=cmd(decelerate,0.25;y,SCREEN_HEIGHT+frame_height)
end

return t
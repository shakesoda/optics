local bgcolor = color("1,0.8,0.115")

local lightcolor = color("1,0.935,0.25")

local t = Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,bgcolor)
	},
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,30;CenterX;diffuse,lightcolor;diffusealpha,0.5),
		OnCommand=cmd(y,SCREEN_BOTTOM-80;linear,2;addy,120;sleep,1;queuecommand,"On")
	},
	elements.roundbox(385,300)..{
		InitCommand=cmd(xy,SCREEN_WIDTH*0.675,SCREEN_CENTER_Y;runcommandsonleaves,cmd(diffuse,lightcolor))
	},
	Def.Quad {
		InitCommand=cmd(diffuse,lightcolor;zoomto,SCREEN_WIDTH,224;xy,0,148;horizalign,left)
	},
	Def.Quad {
		InitCommand=cmd(diffuse,color("0,0,0");zoomto,SCREEN_WIDTH-384,30;horizalign,right;x,SCREEN_RIGHT;y,SCREEN_BOTTOM-60)
	},
	LoadActor(THEME:GetPathG("Common","spinner"))..{
		InitCommand=cmd(diffuse,lightcolor;spin;effectmagnitude,0,0,-100;xy,80,SCREEN_HEIGHT*0.75;zoom,0.65)
	}
}
local j = Def.ActorFrame {
	InitCommand=cmd(y,16),
}

for i=1,20 do
j[#j+1] = Def.Quad {
	InitCommand=cmd(zoomto,math.random(5,25),40;x,math.random(SCREEN_WIDTH);diffuse,lightcolor),
	OnCommand=cmd(linear,1;x,math.random(SCREEN_WIDTH);queuecommand,"On")
}
end

t[#t+1] = j

return t;
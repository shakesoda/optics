local t = Def.ActorFrame {}
local thingy = Def.ActorFrame {
	InitCommand = cmd(xy,SCREEN_CENTER_X*1.125,SCREEN_HEIGHT*0.75),
	StartTransitioningCommand = cmd(sleep,1)
}

local function grey(amount, opacity)
	return { amount, amount, amount, opacity or 1 }
end

local params = {
	tilt = 45,
	width = 250,
	height = 130,
	offset = 20
}

-- black overlay
table.insert(t, Def.Quad {
	InitCommand = function(self)
		self:FullScreen()
	end,
	StartTransitioningCommand = function(self)
		self:diffuse(grey(0, 0))
		self:linear(0.125)
		self:diffuse(grey(0, 0.75))
		self:sleep(0.75)
		self:linear(0.125)
		self:diffusealpha(0)
	end
})

table.insert(thingy, Def.Quad {
	InitCommand = cmd(MaskSource;zoomto,params.width,params.height;x,60;rotationz,params.tilt;y,params.offset),
	StartTransitioningCommand = cmd(decelerate,0.125;x,-90;decelerate,0.75;x,-360;accelerate,0.125;x,-390)
})

table.insert(thingy, Def.Quad {
	InitCommand = cmd(MaskSource;zoomto,params.width,params.height;x,360;rotationz,params.tilt;y,params.offset),
	StartTransitioningCommand = cmd(decelerate,0.125;x,210;decelerate,0.75;x,-60;accelerate,0.125;x,-90)
})

-- white masked quad
table.insert(thingy, Def.Quad {
	InitCommand = cmd(zoomto,SCREEN_WIDTH*0.75,28;diffuse,grey(1,1);MaskDest),
	StartTransitioningCommand = cmd(sleep,0.875;linear,0.125;diffusealpha,0)
})

table.insert(t, thingy)

return t

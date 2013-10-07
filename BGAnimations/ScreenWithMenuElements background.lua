local t = Def.ActorFrame {}

t[#t+1] = LoadActor("_bg")..{
	InitCommand=cmd(scaletocover,0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
}

return t
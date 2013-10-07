local gc = Var "GameCommand"

return Def.ActorFrame {
	LoadFont("Common Normal")..{
		Text=gc:GetName(),
		InitCommand=cmd(shadowlengthy,1.5;shadowcolor,color("0,0,0,0.5")),
		GainFocusCommand=cmd(diffusealpha,1),
		LoseFocusCommand=cmd(diffusealpha,0.5),
		EnabledCommand=cmd(diffuse,color("1,1,1,0.5")),
		DisabledCommand=cmd(diffuse,color("0.5,0.5,0.5,0.5"))
	}
}
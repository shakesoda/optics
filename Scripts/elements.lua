elements = {
	-- super useful for making code less redundant!
	roundbox = function(Width, Height, Color)
		-- code adapted from shakesoda's optical
		assert(Width)
		assert(Height)
		local corner = THEME:GetPathG("Common","corner") -- graphic file
		local DefaultColor = color("0,0,0,0.75") -- black box omg magic

		-- Color is optional.
		if not Color then Color = DefaultColor end

		--[[
		How it's drawn:
		  c----c
		  OOOOOO
		  c----c
	
		---- is 8px tall and Width-8 wide. y = (Height/2), flip the bit.
		OOOO is Height-8px tall and Width wide.
		c's x position is Width - 4, flip the bit if needed.
		--]]
		local EdgeWidth = Width-8
		local EdgePosY = (Height/2)
		local CornerPosX = ((Width/2)-4)

		return Def.ActorFrame {
			BeginCommand=cmd(runcommandsonleaves,cmd(diffuse,Color)),
			-- top
			Def.Quad {
				InitCommand=cmd(zoomto,EdgeWidth-8,8;y,-EdgePosY)
			},
			-- middle
			Def.Quad {
				InitCommand=cmd(zoomto,Width,Height-8)
			},
			-- bottom
			Def.Quad {
				InitCommand=cmd(zoomto,EdgeWidth-8,8;y,EdgePosY)
			},
			-- top left
			LoadActor(corner)..{
				InitCommand=cmd(x,-CornerPosX;y,-EdgePosY)
			},
			-- top right
			LoadActor(corner)..{
				InitCommand=cmd(x,CornerPosX;y,-EdgePosY;rotationz,90)
			},
			-- bottom left
			LoadActor(corner)..{
				InitCommand=cmd(x,-CornerPosX;y,EdgePosY;rotationz,-90)
			},
			-- bottom right
			LoadActor(corner)..{
				InitCommand=cmd(x,CornerPosX;y,EdgePosY;rotationz,180)
			}
		}
	end, -- end roundbox
	sigsig = function()
		return Def.Sprite {
			Texture=THEME:GetPathG("Common","sigsig");
			Frames=Sprite.LinearFrames( 6, 0.5 );
		}
	end
}
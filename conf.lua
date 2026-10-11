function love.conf(t)

	t.title             = "Love Frames Demo"
	t.author            = "Kenny Shields"
	t.version           = "11.2"
	t.identity          = "loveframes-demo"
	
	t.console           = true	 
	t.modules.joystick  = false    
    t.modules.audio     = true      
    t.modules.keyboard  = true   
    t.modules.event     = true      
    t.modules.image     = true      
    t.modules.graphics  = true   
    t.modules.timer     = true      
    t.modules.mouse     = true      
    t.modules.sound     = true      
    t.modules.physics   = false
	t.window.vsync      = false
	t.window.resizable  = false
	
end

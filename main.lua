local loveframes
local tween
local demo = {}

function demo.CreateToolbar()
	local width = love.graphics.getWidth()
	local version = loveframes.version
	local stage = loveframes.stage

	local toolbar = loveframes.Create("panel")
	toolbar:SetSize(width, 35)
	toolbar:SetPos(0, 0)

	local info = loveframes.Create("text", toolbar)
	info:SetPos(5, 3)
	info:SetText({
		{ color = { 0, 0, 0, 1 } },
		"Love Frames (",
		{ color = { .5, .25, 1, 1 } }, "version " .. version .. " - " .. stage,
		{ color = { 0, 0, 0, 1 } }, ")\n",
		{ color = { 1, .4, 0, 1 } }, "F1",
		{ color = { 0, 0, 0, 1 } }, ": Toggle debug mode - ",
		{ color = { 1, .4, 0, 1 } }, "F2",
		{ color = { 0, 0, 0, 1 } }, ": Remove all objects"
	})

	demo.examplesbutton = loveframes.Create("button", toolbar)
	demo.examplesbutton:SetPos(toolbar:GetWidth() - 105, 5)
	demo.examplesbutton:SetSize(100, 25)
	demo.examplesbutton:SetText("Hide Examples")
	demo.examplesbutton.OnClick = function()
		demo.ToggleExamplesList()
	end

	local skinslist = loveframes.Create("multichoice", toolbar)
	skinslist:SetPos(toolbar:GetWidth() - 250, 5)
	skinslist:SetWidth(140)
	skinslist:SetChoice("Choose a skin")
	skinslist.OnChoiceSelected = function(object, choice)
		loveframes.SetActiveSkin(choice)
	end

	local skins = loveframes.skins
	for k, v in pairs(skins) do
		skinslist:AddChoice(v.name)
	end
	skinslist:Sort()
end

function demo.RegisterExample(example)
	local examples = demo.examples
	local category = example.category

	for k, v in ipairs(examples) do
		if v.category_title == category then
			table.insert(examples[k].registered, example)
		end
	end
end

function demo.CreateExamplesList()
	local examples = demo.examples
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	demo.exampleslist = loveframes.Create("list")
	demo.exampleslist:SetPos(width - 250, 35)
	demo.exampleslist:SetSize(250, height - 35)
	demo.exampleslist:SetPadding(5)
	demo.exampleslist:SetSpacing(5)
	demo.exampleslist.toggled = true

	demo.tween_open           = tween.new(1, demo.exampleslist, { x = (width - 250) }, "outBounce")
	demo.tween_close          = tween.new(1, demo.exampleslist, { x = (width - 5) }, "outBounce")

	for k, v in ipairs(examples) do
		local panelheight = 0
		local category = loveframes.Create("collapsiblecategory")
		category:SetText(v.category_title)
		local panel = loveframes.Create("panel")
		panel.Draw = function() end
		demo.exampleslist:AddItem(category)
		for key, value in ipairs(v.registered) do
			local button = loveframes.Create("button", panel)
			button:SetWidth(210)
			button:SetPos(0, panelheight)
			button:SetText(value.title)
			button.OnClick = function()
				value.func(loveframes, demo.centerarea)
				demo.current = value
			end
			panelheight = panelheight + 30
		end
		panel:SetHeight(panelheight)
		category:SetObject(panel)
		category:SetOpen(true)
	end
end

function demo.ToggleExamplesList()
	local toggled = demo.exampleslist.toggled

	if not toggled then
		demo.exampleslist.toggled = true
		demo.tween = demo.tween_open
		demo.examplesbutton:SetText("Hide Examples")
	else
		demo.exampleslist.toggled = false
		demo.tween = demo.tween_close
		demo.examplesbutton:SetText("Show Examples")
	end

	demo.tween:reset()
end

function love.load()
	local font = love.graphics.newFont(12)
	love.graphics.setFont(font)

	loveframes = require("loveframes")
	tween = require("demo.tween")

	-- Change fonts on all registered skins
	for _, skin in pairs(loveframes.skins) do
		skin.controls.smallfont = love.graphics.newFont("demo/resources/FreeSans-LrmZ.ttf", 12)
		skin.controls.imagebuttonfont = love.graphics.newFont("demo/resources/FreeSans-LrmZ.ttf", 15)
	end

	-- table to store available examples
	demo.examples = {}
	demo.examples[1] = { category_title = "Object Demonstrations", registered = {} }
	demo.examples[2] = { category_title = "Example Implementations", registered = {} }

	demo.exampleslist = nil
	demo.examplesbutton = nil
	demo.tween = nil
	demo.centerarea = { 5, 40, 540, 555 }

	local files = loveframes.GetDirectoryContents("demo/examples")
	local example
	for k, v in ipairs(files) do
		if v.extension == "lua" then
			example = require(v.requirepath)
			demo.RegisterExample(example)
		end
	end

	local image = love.graphics.newImage("demo/resources/background.png")
	image:setWrap("repeat", "repeat")
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	demo.bgquad = love.graphics.newQuad(0, 0, width, height, image:getWidth(), image:getHeight())
	demo.bgimage = image

	-- create demo gui
	demo.CreateToolbar()
	demo.CreateExamplesList()
end

function love.update(dt)
	loveframes.update(dt)
	if demo.tween then
		if demo.tween:update(dt) then demo.tween = nil end
	end
end

function love.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(demo.bgimage, demo.bgquad, 0, 0)
	loveframes.draw()
end

function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
	local menu = loveframes.hoverobject and loveframes.hoverobject.menu_example
	if menu and button == 2 then
		menu:SetPos(x, y)
		menu:SetVisible(true)
		menu:MoveToTop()
	end
end

function love.mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
	loveframes.wheelmoved(x, y)
end

function love.keypressed(key, isrepeat)
	loveframes.keypressed(key, isrepeat)

	if key == "f1" then
		local debug = loveframes.config["DEBUG"]
		loveframes.config["DEBUG"] = not debug
	elseif key == "f2" then
		loveframes.RemoveAll()
		demo.CreateToolbar()
		demo.CreateExamplesList()
		--demo.ToggleExamplesList()
	end
end

function love.keyreleased(key)
	loveframes.keyreleased(key)
end

function love.textinput(text)
	loveframes.textinput(text)
end

extends Camera2D

var ssCount = 1

func _ready():
	var dir = DirAccess.open("user://")
	if dir and not dir.dir_exists("screenshots"):
		dir.make_dir("screenshots")
	
	dir = DirAccess.open("user://screenshots")
	if dir:
		for n in dir.get_files():
			ssCount += 1

func _input(event):
	if event.is_action_pressed("screenshot"):
		screenshot()

func screenshot():
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png("user://screenshots/ss" + str(ssCount) + ".png")
	ssCount += 1

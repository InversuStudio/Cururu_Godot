extends Control

@export var speed: float = 50.0
@export var start_delay: float = 0.5
@export var end_delay: float = 1.0
@export var next_scene: String = ""

@onready var credits: TextureRect = $TextureRect

var is_scrolling: bool = false


func _ready() -> void:
	clip_contents = true
	
	await get_tree().process_frame
	
	if credits.texture == null:
		push_error("TextureRect está sem imagem de créditos.")
		return
	
	var tex_size: Vector2 = credits.texture.get_size()
	credits.size = tex_size
	
	# Começa totalmente abaixo da área visível
	credits.position = Vector2(
		(size.x - tex_size.x) / 2.0,
		size.y
	)
	
	if start_delay > 0.0:
		await get_tree().create_timer(start_delay).timeout
	
	is_scrolling = true


func _process(delta: float) -> void:
	if not is_scrolling:
		return
	
	credits.position.y -= speed * delta
	
	# Quando a parte de baixo da imagem passar do topo da área
	if credits.position.y + credits.size.y < 0:
		is_scrolling = false
		
		if end_delay > 0.0:
			await get_tree().create_timer(end_delay).timeout
		
		if next_scene != "":
			get_tree().change_scene_to_file(next_scene)

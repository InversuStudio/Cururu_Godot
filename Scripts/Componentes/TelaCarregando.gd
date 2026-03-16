extends Control

var terminou:bool = false

func _ready() -> void:
	get_tree().paused = false
	ResourceLoader.load_threaded_request(Mundos.prox_fase_path)

func _process(_delta: float) -> void:
	var status:ResourceLoader.ThreadLoadStatus = (
		ResourceLoader.load_threaded_get_status(Mundos.prox_fase_path))
	
	if !terminou and status == ResourceLoader.THREAD_LOAD_LOADED:
		var cena:PackedScene = ResourceLoader.load_threaded_get(Mundos.prox_fase_path)
		get_tree().change_scene_to_packed(cena)
		
		# Registra novo HUD na cena
		HUD.IniciaHUD()
		Mundos.fase_mudou.emit()
		
		# Inicia Fade In
		Fade.FadeIn()
		

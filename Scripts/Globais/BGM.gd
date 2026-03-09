extends AudioStreamPlayer

func _ready() -> void:
	volume_linear = 0.0
	
@onready var bgm_global: AudioStreamPlayer = $"."

func TocaMusica(musica:AudioStream = null, vol:float = 1.0) -> void:
	#Fade Out
	if playing and stream != musica:
		print("Saindo")
		var tween:Tween = get_tree().create_tween()
		tween.tween_property(bgm_global, "volume_linear", 0.0, .5).from(volume_linear)
		await tween.finished
	
	# Fase In
	if stream != musica:
		if stream == musica: return
		print("Tocando")
		stream = musica
		var tween:Tween = get_tree().create_tween()
		tween.tween_property(self, "volume_linear", vol, .5).from(0.0)
		play()
	
func FadeSom(vol:float) -> void:
	volume_db = linear_to_db(vol)

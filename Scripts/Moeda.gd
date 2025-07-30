extends Area2D

@export var valor_moeda: int = 1
@export var sfx: AudioStream = null

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GameData.moedas += valor_moeda
		%Imagem.hide()
		if sfx:
			var som: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			som.stream = sfx
			get_parent().add_child(som)
			som.play()
			await som.finished
			som.queue_free()
		queue_free()

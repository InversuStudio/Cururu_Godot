extends Area2D

## Valor a ser somado a quantia total
@export var valor_moeda: int = 1
## Efeito sonoro aoser coletado
@export var sfx: AudioStream = null

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Desabilita colisão
		set_deferred("monitoring", false)
		# Soma valor ao total obtido
		GameData.moedas += valor_moeda
		# Esconde sprite
		%Imagem.hide()
		# Toca som
		if sfx:
			var som: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			som.stream = sfx
			get_parent().add_child(som)
			som.play()
			await som.finished
			som.queue_free()
		# Deleta
		queue_free()

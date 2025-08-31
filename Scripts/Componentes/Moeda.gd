extends Area2D

## Valor a ser somado a quantia total
@export var valor_moeda: int = 1
## Efeito sonoro aoser coletado
@export var sfx: AudioStream = null

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	if sfx: $SFX.stream = sfx

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Desabilita colisão
		set_deferred("monitoring", false)
		# Soma valor ao total obtido
		GameData.moedas += valor_moeda
		# Esconde sprite
		$Imagem.hide()
		# Toca som
		if sfx:
			$SFX.play()
			return
		# Deleta
		queue_free()

func _on_sfx_finished() -> void:
	queue_free()

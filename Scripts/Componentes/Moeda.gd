extends Area2D

## Valor a ser somado a quantia total
@export var valor_moeda: int = randi_range(1, 8)
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
		Console._Print(GameData.moedas)
		# Esconde sprite
		$Imagem.hide()
		# Toca som
		if sfx:
			var s:AudioStreamPlayer = AudioStreamPlayer.new()
			s.stream = sfx
			get_tree().current_scene.add_child(s)
			s.finished.connect(SfxTocou.bind(s))
			s.volume_db = -5.0
			s.play()
			return
		# Deleta
		queue_free()

func SfxTocou(s:AudioStreamPlayer) -> void:
	s.queue_free()
	call_deferred("queue_free")

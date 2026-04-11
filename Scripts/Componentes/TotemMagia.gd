extends Node2D

## Porcentagem da magia total a ser recuperada
@export_range(1, 100, 1, "suffix:%") var magia_a_recuperar: float = 50

func Morte() -> void:
	GameData.magia_atual += (magia_a_recuperar / 100.0) * GameData.magia_max
	$Sprite.play("Quebrando")
	await $Sprite.animation_finished
	queue_free()

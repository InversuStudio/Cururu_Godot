extends Node2D

@onready var id: String = str(Mundos.fase_atual) + name

## Porcentagem da magia total a ser recuperada
@export_range(1, 100, 1, "suffix:%") var magia_a_recuperar: float = 50

var quebrado: bool = false

func _ready() -> void:
	# Se já foi quebrado antes, se deleta
	for i: String in Mundos.lista_baus:
		if i == id:
			queue_free()
			return

func Morte() -> void:
	if quebrado:
		return
	quebrado = true
	Mundos.lista_baus.append(id)
	$HurtBox.set_deferred("monitorable", false)
	GameData.magia_atual += (magia_a_recuperar / 100.0) * GameData.magia_max
	$Sprite.play("Quebrando")
	await $Sprite.animation_finished
	queue_free()

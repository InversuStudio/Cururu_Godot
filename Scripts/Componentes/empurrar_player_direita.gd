extends Area2D

## Tiles a mover ao colidir, em m/s
@export var forca:int = 5

func _ready() -> void:
	connect("body_entered", ProjetaPlayer)

func ProjetaPlayer(body: Node2D) -> void:
	if body.is_in_group("Player") and GameData.veio_de_baixo:
		if body.sprite.flip_h:
			body.velocity.x = -forca * 128.0
		else:
			body.velocity.x = forca * 128.0
		queue_free()

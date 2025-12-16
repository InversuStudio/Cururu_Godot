extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and GameData.veio_de_baixo:
		if body.sprite.flip_h:
			body.velocity.x = -2500
		else:
			body.velocity.x = 2500
		queue_free()

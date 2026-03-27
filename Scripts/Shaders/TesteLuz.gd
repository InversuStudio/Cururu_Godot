extends Sprite2D

func _physics_process(_delta: float) -> void:
	if Mundos.player:
		global_position = Mundos.player.global_position

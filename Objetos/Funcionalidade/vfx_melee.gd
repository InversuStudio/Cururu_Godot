extends Node2D

func _ready() -> void:
	var c:AnimatedSprite2D = $Animation
	var hit_col:CollisionPolygon2D = $HitBox/CollisionPolygon2D
	hit_col.set_deferred("disabled", true)
	c.frame_changed.connect(func():
		if c.frame >= 1:
			hit_col.set_deferred("disabled", false))

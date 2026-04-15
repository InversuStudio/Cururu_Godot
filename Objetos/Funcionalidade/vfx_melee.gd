extends Node2D

func _ready() -> void:
	var c:AnimatedSprite2D = $Animation
	var hit_col:CollisionPolygon2D = $HitBox/CollisionPolygon2D
	hit_col.set_deferred("disabled", true)
	
	# Calcula metade da duração do primeiro frame
	var frame_duration:float = (1.0 / c.sprite_frames.get_animation_speed(c.animation)) / c.speed_scale
	var meio_frame:float = frame_duration * 0.5  # ← ajusta esse multiplicador (0.5 = meio frame)
	
	await get_tree().create_timer(meio_frame).timeout
	hit_col.set_deferred("disabled", false)

extends Node2D

@export var speed:Vector2 = Vector2(1,0)

func _process(delta: float) -> void:
	global_position += speed * 128 * delta

func _on_hit_box_hit() -> void:
	Console._Print("PAPAPAPAPAPAP")
	queue_free()

func _on_hit_box_body_entered(_body: Node2D) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()

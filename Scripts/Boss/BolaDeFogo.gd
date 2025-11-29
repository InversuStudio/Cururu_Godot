extends Node2D

@export var speed:Vector2 = Vector2(1,0)

func _process(delta: float) -> void:
	global_position += speed * 128 * delta

func _on_hit_box_hit(_pos:Vector2) -> void:
	Desabilita()

func _on_hit_box_body_entered(_body: Node2D) -> void:
	Desabilita()

func _on_timer_timeout() -> void:
	queue_free()

func Desabilita() -> void:
	$SFX_End.play()
	$Sprite.hide()
	%Col.set_deferred("disabled", true)
	

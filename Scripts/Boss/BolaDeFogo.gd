extends Node2D

@export var speed:float = 1.0
@export var offset_target:Vector2 = Vector2(0.0, -200)
var target_dir:Vector2 = Vector2.ZERO

func _ready() -> void:
	speed *= 128
	look_at(Mundos.player.global_position + offset_target)

func _physics_process(delta: float) -> void:
	global_position += target_dir * speed * delta
	
func _on_hit_box_hit(_pos:Vector2, _l:int) -> void:
	Desabilita()

func _on_hit_box_body_entered(_body: Node2D) -> void:
	Desabilita()

func _on_timer_timeout() -> void:
	queue_free()

func Desabilita() -> void:
	$SFX_End.play()
	$Sprite.hide()
	%Col.set_deferred("disabled", true)
	

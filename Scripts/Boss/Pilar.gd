extends Node2D

# Tempo de animação de carga do pilar
var tempo_carga:float = 0.0

func _ready() -> void:
	$HitBox.set_deferred("monitoring", false)
	$Timer.start(tempo_carga)

func _on_timer_timeout() -> void:
	$Anim.play("Sobe")
	await $Anim.animation_finished
	queue_free()

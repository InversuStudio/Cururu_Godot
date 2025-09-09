extends Node2D

func _on_hurt(hitbox:Array) -> void:
	print(hitbox)
	if hitbox and hitbox[0].get_parent().is_in_group("Magia"):
		Disable()

func _on_timer_timeout() -> void:
	Enable()

func Disable() -> void:
	%Anim.play("Abre")
	%HurtBox.set_deferred("monitoring", false)
	%HurtBox.set_deferred("monitorable", false)
	%Timer.start()

func Enable() -> void:
	%Anim.play("Fecha")
	%HurtBox.set_deferred("monitoring", true)
	%HurtBox.set_deferred("monitorable", true)

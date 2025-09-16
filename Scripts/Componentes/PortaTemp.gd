extends Node2D

@export var tempo_aberta:float = 3.0

func _ready() -> void:
	%HurtBox.connect("hurt", _on_hurt)
	%Timer.wait_time = tempo_aberta
	%HurtBox.set_deferred("monitoring", true)
	%HurtBox.set_deferred("monitorable", true)

func _on_hurt(hitbox:HitBox) -> void:
	if hitbox and hitbox.is_in_group("Special"):
		Console._Print("SPECIAL")
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

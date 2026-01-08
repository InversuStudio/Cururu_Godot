extends Node2D

@export var tempo_aberta:float = 3.0

func _ready() -> void:
	%HurtBox.connect("hurt", _on_hurt)
	%HurtBox.set_deferred("monitoring", true)
	%HurtBox.set_deferred("monitorable", true)
	%HitBox.set_deferred("monitoring", true)
	%HitBox.set_deferred("monitorable", true)

func _on_hurt(hitbox:Array[HitBox]) -> void:
	for h:HitBox in hitbox:
		if h.is_in_group("Special"):
			Console._Print("SPECIAL")
			Disable()

func _on_timer_timeout() -> void:
	Enable()

func Disable() -> void:
	%Anim.play("Abre")
	%SFX.play()
	%HurtBox.set_deferred("monitoring", false)
	%HurtBox.set_deferred("monitorable", false)
	%Timer.start(tempo_aberta)

func Enable() -> void:
	%Anim.play("Fecha")
	%SFX.play()
	%HurtBox.set_deferred("monitoring", true)
	%HurtBox.set_deferred("monitorable", true)

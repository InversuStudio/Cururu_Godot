extends Node2D

@export var tempo_aberta:float = 3.0

const sfx:Array[AudioStream] = [
	preload("res://Audio/SFX/AMBIENTE/Porta Miasma Iddle.wav"),
	preload("res://Audio/SFX/AMBIENTE/Porta miasma Abrindo.wav"),
	preload("res://Audio/SFX/AMBIENTE/Porta miasma fechando.wav")
]

func _ready() -> void:
	%HurtBox.connect("hurt", _on_hurt)
	%HurtBox.set_deferred("monitorable", true)
	%HitBox.set_deferred("monitoring", true)
	%SFX.stream = sfx[0]

func _on_hurt(hitbox:Array[HitBox]) -> void:
	for h:HitBox in hitbox:
		if h.is_in_group("Special"):
			Disable()

func Disable() -> void:
	%Anim.play("Abre")
	%HurtBox.set_deferred("monitorable", false)
	%HitBox.set_deferred("monitoring", false)
	%ColFis.set_deferred("disabled", true)
	%Timer.start(tempo_aberta)

func _on_timer_timeout() -> void:
	Enable()
	
func Enable() -> void:
	%Anim.play("Fecha")
	%HurtBox.set_deferred("monitorable", true)
	%HitBox.set_deferred("monitoring", true)
	%ColFis.set_deferred("disabled", false)
	await %Anim.animation_finished
	%SFX.stream = sfx[0]

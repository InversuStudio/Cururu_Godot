class_name HurtBox
extends Area2D

## Componente Vida
@export var comp_vida : Vida
## Distância do knockback, em metros
@export var distancia_knockback : float = 0.0
## Duração do knockback, em segundos
@export var tempo_knockback : float = 0.0
## Cooldown para receber dano novamente
@export var cooldown_dano: float = 0.2
## Som de acerto
@export var hit_sfx : AudioStream = null
## Recebe o node pai
@export var parent: Node2D = null

signal hurt
signal counter

func _ready() -> void:
	if hit_sfx: %SFX.stream = hit_sfx
	%Timer.wait_time = cooldown_dano

# FUNÇÃO DE RECEBER DANO
func RecebeDano(dano:int, pos_target:Vector2):
	# Se houver componente de vida, recebe dano
	if comp_vida:
		comp_vida.RecebeDano(dano)
	# Aplica knockback, se for definido
	if distancia_knockback > 0.0 and parent != null:
		# Define direção do knockback
		var dir:Vector2 = (global_position - pos_target).normalized()
		# Define a força do knockback
		var knockback:float = ((2.0 * distancia_knockback) / tempo_knockback) * 128
		# Calcula a velocidade a ser aplicada
		var result_vel:Vector2 = dir * knockback
		if parent is CharacterBody2D:
			# Aplica velocidade
			parent.velocity = result_vel
			# Calcula força oposta (desaceleração)
			var c:float = ((2.0 * distancia_knockback) / pow(tempo_knockback, 2)) * 128
			counter.emit(c, dir)
	call_deferred("AchaHit")
	# Desabilita colisão
	set_deferred("monitorable", false)
	# Toca som de dano
	if hit_sfx: %SFX.play()
	# Inicia cooldown
	%Timer.start()

func AchaHit() -> void:
	var areas:Array[Area2D] = get_overlapping_areas()
	var hitbox:Array[HitBox] = []
	for a:Area2D in areas:
		if a is HitBox:
			hitbox.append(a)
	hurt.emit(hitbox)

func _on_timer_timeout() -> void:
	set_deferred("monitorable", true)

class_name HurtBox
extends Area2D

## Componente Vida
@export var comp_vida : Vida
## Distância do knockback, em metros
@export var distancia_knockback : float = 0.0
## Duração do knockback, em segundos
@export var tempo_knockback : float = 0.0
## Cooldown para receber dano novamente
@export var cooldown_dano: float = 0.5
## Som de acerto
@export var hit_sfx : AudioStream = null
## Recebe o node pai
@export var parent: Node2D = null

# FUNÇÃO DE RECEBER DANO
func recebe_dano(dano:int, pos_target:Vector2):
	print("Dano")
	# Desabilita colisão
	set_deferred("monitorable", false)
	# Se houver componente de vida, recebe dano
	if comp_vida:
		comp_vida.recebe_dano(dano)
	# Aplica knockback, se for definido
	if distancia_knockback > 0.0 and parent != null:
		parent.velocity = Vector2.ZERO
		var dir = (global_position - pos_target).normalized()
		var knockback = (distancia_knockback * 128) / tempo_knockback
		if parent is CharacterBody2D:
			parent.velocity = dir * knockback
	# Toca som de dano
	TocaSom()
	# Inicia cooldown
	Cooldown()

func TocaSom() -> void:
	var som := AudioStreamPlayer2D.new()
	som.stream = hit_sfx
	get_tree().root.add_child(som)
	som.global_position = global_position
	som.play()
	await som.finished
	som.queue_free()
	
func Cooldown() -> void:
	var timer: Timer = Timer.new()
	timer.wait_time = cooldown_dano
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	set_deferred("monitorable", true)
	timer.queue_free()

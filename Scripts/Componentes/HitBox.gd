class_name HitBox
extends Area2D

## Dano aplicado a uma HurtBox
@export var dano: int = 1
## Hurtbox a ser ignorada
@export var ignore : HurtBox = null
## Efeito sonoro
@export var sfx : AudioStream = null
## Recebe o node pai
@export var parent: Node2D = null
## O quanto a câmera vai tremer ao acertar
@export var camera_shake:float = 10.0
## Tempo que jogo congela ao acertar
@export var hit_freeze:float = .05

signal hit
#signal pushback

func _ready() -> void:
	if sfx: $SFX.stream = sfx

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox: # Se a colisão for uma HurtBox
		if area == ignore: return
		hit.emit(area.global_position)
		area.RecebeDano(dano, global_position)
		if hit_freeze > 0.0:
			Engine.time_scale = 0.0
			await get_tree().create_timer(hit_freeze, true, false, true).timeout
			Engine.time_scale = 1.0
		if get_tree().get_first_node_in_group("MainCamera"):
			get_tree().get_first_node_in_group("MainCamera").Shake(camera_shake)
		# Toca som
		if sfx:
			$SFX.play()

func CalcPushback(dist:float, time:float, pos_target:Vector2) -> void:
	# Define direção do knockback
	var dir:Vector2 = (global_position - pos_target).normalized()
	# Define a força do knockback
	var knockback:float = ((2.0 * dist) / time) * 128
	# Calcula a velocidade a ser aplicada
	var result_vel:Vector2 = dir * knockback
	if parent is CharacterBody2D:
		# Aplica velocidade
		parent.velocity = result_vel
		# Calcula força oposta (desaceleração)
		#var c:float = ((2.0 * dist) / pow(time, 2)) * 128
		#pushback.emit(c, dir)

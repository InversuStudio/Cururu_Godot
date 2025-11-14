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

signal hit
#signal pushback

func _ready() -> void:
	if sfx: $SFX.stream = sfx

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox: # Se a colisão for uma HurtBox
		if area == ignore: return
		hit.emit(area.global_position)
		area.RecebeDano(dano, global_position)
		# Toca som
		if sfx:
			$SFX.play()
	
# FUNÇÃO DE APLICAR SCREEN SHAKE
func aplica_shake():
	pass

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

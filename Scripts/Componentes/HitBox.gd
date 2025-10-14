class_name HitBox
extends Area2D

## Dano aplicado a uma HurtBox
@export var dano: int = 1
## Hurtbox a ser ignorada
@export var ignore : HurtBox = null
## Efeito sonoro
@export var sfx : AudioStream = null

signal hit

func _ready() -> void:
	if sfx: $SFX.stream = sfx

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox: # Se a colisão for uma HurtBox
		if area == ignore: return
		hit.emit()
		area.RecebeDano(dano, global_position)
		# Toca som
		if sfx:
			$SFX.play()
	
# FUNÇÃO DE APLICAR SCREEN SHAKE
func aplica_shake():
	pass

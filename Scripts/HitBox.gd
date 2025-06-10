class_name HitBox
extends Area2D

## Força de vibração da tela
@export var screenshake : float = 0.0

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox: # Se a colisão for uma HurtBox
		aplica_dano()
		# Se screenshake for maior que 0, aplicar vibração na tela
		if screenshake > 0: aplica_shake()

# FUNÇÃO DE APLICAR DANO
func aplica_dano():
	pass
	
# FUNÇÃO DE APLICAR SCREEN SHAKE
func aplica_shake():
	pass

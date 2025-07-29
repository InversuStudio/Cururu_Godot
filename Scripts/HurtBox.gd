class_name HurtBox
extends Area2D

## Componente Vida
@export var comp_vida : Vida
## Força do knockback
@export var knockback : float = 0.0
## Som de acerto
@export var hit_sfx : AudioStream = null

# FUNÇÃO DE RECEBER DANO
func recebe_dano(ataque : Ataque):
	print("AIAIAIAIAIIA")
	# Se houver componente de vida, recebe dano
	if comp_vida:
		comp_vida.recebe_dano(ataque)
		# Se vida for zerada, morre
		if comp_vida.vida_atual <= 0:
			morre()
	
	# Toca som de dano
	var som := AudioStreamPlayer2D.new()
	som.stream = hit_sfx
	get_tree().root.add_child(som)
	som.global_position = global_position
	som.play()
	await som.finished
	som.queue_free()

# FUNÇÃO DE MORRER
func morre():
	print("MORRI")
	get_parent().queue_free()

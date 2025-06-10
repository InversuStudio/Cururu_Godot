class_name HurtBox
extends Area2D

## Componente Vida
@export var comp_vida : Vida
## Força do knockback
@export var knockback : float = 0.0
## Som de acerto
@export var hit_sfx : AudioStream

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("teste"):
		var atk : Ataque = Ataque.new()
		atk.dano = 500
		recebe_dano(atk)

# FUNÇÃO DE RECEBER DANO
func recebe_dano(ataque : Ataque):
	# Se houver componente de vida, recebe dano
	if comp_vida:
		comp_vida.recebe_dano(ataque)
		# Se vida for zerada, morre
		if comp_vida.vida_atual <= 0:
			morre()
	
	# Toca som de dano
	var som := AudioStreamPlayer2D.new()
	som.stream = hit_sfx
	add_sibling(som)
	som.play()
	await som.finished
	som.queue_free()

func morre():
	print("MORRI")
	get_parent().queue_free()

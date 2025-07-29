class_name HitBox
extends Area2D

## Dano aplicado a uma HurtBox
@export var dano: int = 1
#@export var knockback: float = 0.0
@export var tempo_stun: float = 0.0
## Força de vibração da tela
@export var screenshake : float = 0.0
## Hurtbox a ser ignorada
@export var ignore : HurtBox = null
## Efeito sonoro
@export var sfx : AudioStream = null

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox: # Se a colisão for uma HurtBox
		if area == ignore: return
		
		print(area.get_parent().name)
		var ataque:Ataque = Ataque.new()
		ataque.dano = dano
		ataque.tempo_stun = tempo_stun
		#ataque.knockback = knockback
		
		area.recebe_dano(ataque)
		
		# Toca som
		if sfx:
			var som := AudioStreamPlayer2D.new()
			som.stream = sfx
			get_tree().root.add_child(som)
			som.global_position = global_position
			som.play()
			await som.finished
			som.queue_free()
		
		# Se screenshake for maior que 0, aplicar vibração na tela
		if screenshake > 0: aplica_shake()
	
# FUNÇÃO DE APLICAR SCREEN SHAKE
func aplica_shake():
	pass

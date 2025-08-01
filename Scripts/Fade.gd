class_name Fade
extends ColorRect

# Script para poder chamar animação de fade out
# durante troca de cena
signal terminou

func FadeOut() -> void:
	%Anim.play("FadeOut")
	await %Anim.animation_finished
	terminou.emit()

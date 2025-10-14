extends CanvasLayer

# Script para poder chamar animação de fade out
# durante troca de cena
signal terminou

func FadeOut() -> void:
	%Anim.play("FadeOut")
	await %Anim.animation_finished
	terminou.emit()

func FadeIn() -> void:
	%Anim.play("FadeIn")
	await %Anim.animation_finished
	terminou.emit()

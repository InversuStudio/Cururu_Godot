extends CanvasLayer

# Script para poder chamar animação de fade out
# durante troca de cena
signal terminou

func _ready() -> void:
	%Anim.connect("animation_finished", func(_an:StringName)->void:
		terminou.emit())
	FadeIn()

func FadeOut() -> void:
	%Anim.play("FadeOut")

func FadeIn() -> void:
	%Anim.play("FadeIn")

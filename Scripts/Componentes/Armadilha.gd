extends Node2D

## 2 Areas2D (esquerda e direita) que definem onde o player deve respawnar após dano.[br]
## [b]Se estiver vazio, não faz nada.[/b]
@export var spawn_points:Array[Area2D] = [null, null]

var ponto:Vector2

func _ready() -> void:
	if spawn_points[0] != null and spawn_points[1] != null:
		for sp:Area2D in spawn_points:
			sp.collision_layer = 0
			sp.collision_mask = 2
			sp.body_entered.connect(func(body:Node2D):
				if body.is_in_group("Player"):
					ponto = sp.global_position)
	
func _on_hit_box_hit(_p:Vector2, layer:int) -> void:
	print_rich("[color=yellow]Collision Layer: %s[/color]" % [layer])
	# Os IDs das collision layers são múltiplos de 2
	# O ID 8 é a camada da Hit/Hurt do Player
	if layer != 8: return
	if spawn_points[0] != null and spawn_points[1] != null:
		Fade.FadeOut()
		await Fade.terminou
		Mundos.player.global_position = ponto
		Fade.FadeIn()

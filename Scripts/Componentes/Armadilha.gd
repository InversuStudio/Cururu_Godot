extends Node2D

## 2 Areas2D (esquerda e direita) que definem onde o player deve respawnar após dano.[br]
## [b]Se estiver vazio, não faz nada.[/b]
@export var spawn_points:Array[Area2D] = [null, null]

var ponto:Vector2

func _ready() -> void:
	if spawn_points.size() > 0:
		for sp:Area2D in spawn_points:
			sp.body_entered.connect(func(body:Node2D):
				if body.is_in_group("Player"):
					ponto = sp.global_position)
	
func _on_hit_box_hit() -> void:
	if spawn_points.size() > 0:
		Fade.FadeOut()
		await Fade.terminou
		get_tree().get_first_node_in_group("Player").global_position = ponto
		Fade.FadeIn()

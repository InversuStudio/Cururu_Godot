class_name Secret
extends Area2D

## Sprite/Tilemap que esconde a área
@export var area_escondida: Node2D = null
## Define se, ao retornar a fase, ela volta a ficar escondida
@export var continuar_escondida:bool = false
## Nome da área secreta.[br]Usada na lógica de permanência ao ser destruída.
@export var nome_id:String = ""
var dentro: bool = false

func _ready() -> void:
	for i:String in Mundos.areas_secretas:
		if i == nome_id:
			area_escondida.queue_free()
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		dentro = true
		if !continuar_escondida and nome_id != "":
			Mundos.areas_secretas.append(nome_id)
			
func _on_body_exited(body: Node2D) -> void:
	if  body.is_in_group("Player") and continuar_escondida:
		dentro = false

func _process(delta: float) -> void:
	# "Animação" de fade
	if dentro == true: area_escondida.self_modulate.a = move_toward(
		area_escondida.self_modulate.a, 0.0, delta * 10)
	else: area_escondida.self_modulate.a = move_toward(
		area_escondida.self_modulate.a, 1.0, delta * 10)
	
	if area_escondida.self_modulate.a == 0.0 and !continuar_escondida:
		queue_free()

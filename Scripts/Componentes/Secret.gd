class_name Secret
extends Node2D

## Sprite/Tilemap que esconde a área
@export var area_escondida: Node2D = null
## Recebe a parede a ser destruída para revelar a área secreta
@export var parede_falsa:Node2D = null
## Nome da área secreta.[br]Usada na lógica de permanência ao ser destruída.
@export var nome_id:String = ""

signal ta_na_hora

func _ready() -> void:
	for i:String in Mundos.areas_secretas:
		if i == nome_id:
			area_escondida.queue_free()
			parede_falsa.queue_free()
			queue_free()
	if parede_falsa:
		connect("ta_na_hora", QuebrouParede)
			
func QuebrouParede() -> void:
	if nome_id != "":
		Mundos.areas_secretas.append(nome_id)
		var tween:Tween = create_tween()
		tween.tween_property(area_escondida, "modulate", Color(.0,.0,.0,.0), .5)
		await tween.finished
		area_escondida.queue_free()
		queue_free()

func _process(_delta: float) -> void:
	if !is_instance_valid(parede_falsa):
		print_rich("[color=red]ME DEIXOU E FOI EMBORA[/color]")
		ta_na_hora.emit()

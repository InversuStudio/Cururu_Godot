extends Node

const console_file:PackedScene = preload('res://Objetos/Funcionalidade/DebugConsole.tscn')
var ativo:bool = false

func _ready() -> void:
	get_tree().scene_changed.connect(AddConsole)
	AddConsole()

func AddConsole():
	var canvas: CanvasLayer = CanvasLayer.new()
	get_tree().current_scene.add_child(canvas)
	var c:DebugConsole = console_file.instantiate()
	canvas.add_child(c)
	c.AddTexto("Cena carregada: " + get_tree().current_scene.name)

func _Print(text:Variant) -> void:
	var console:DebugConsole = get_tree().get_first_node_in_group("Console")
	if console:
		console.AddTexto(str(text))

class_name OtimizadorSprite
extends VisibleOnScreenEnabler2D

var parent: Node2D = null
## Define se segue objeto alvo
@export var follow:bool = false

func _ready() -> void:
	parent = get_parent() # Recebe o node pai original
	name = "OPT_" + parent.name # Muda seu nome (para debug)
	call_deferred("reparent", get_tree().current_scene) # Vira filho da cena
	enable_node_path = parent.get_path() # Atualiza caminho até pai original
	connect("screen_entered", Aparece) # Conecta funções de entrada/saída
	connect("screen_exited", Some)
	if !follow: set_process(false) # Desabilita _process se não for seguir pai

func Aparece() -> void:
	if parent == null:
		Console._Print("%s deletado" % [name])
		queue_free()
		return
	Console._Print("[color=orange]%s(%s) APARECEU[/color]" % [
		parent.name, parent.get_class()])
	parent.show()

func Some() -> void:
	if parent == null:
		Console._Print("%s deletado" % [name])
		queue_free()
		return
	Console._Print("[color=red]%s(%s) SUMIU[/color]" % [
		parent.name, parent.get_class()])
	parent.hide()

func _process(_delta: float) -> void:
	# Se habilitado, segue node pai original
	if follow and parent: global_position = parent.global_position

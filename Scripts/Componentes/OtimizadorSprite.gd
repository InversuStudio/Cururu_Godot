class_name OtimizadorSprite
extends VisibleOnScreenEnabler2D

var parent: Node2D = null
## Define se segue objeto alvo
@export var follow:bool = false

func _ready() -> void:
	parent = get_parent()
	name = "OPT_" + parent.name
	#var grandad: Node = parent.get_parent()
	#await grandad.ready
	call_deferred("reparent", get_tree().current_scene)#grandad)
	enable_node_path = parent.get_path()
	connect("screen_entered", Aparece)
	connect("screen_exited", Some)

func Aparece() -> void:
	Console._Print("[color=orange]%s(%s) APARECEU[/color]" % [parent.name, parent.get_class()])
	parent.show()

func Some() -> void:
	Console._Print("[color=red]%s(%s) SUMIU[/color]" % [parent.name, parent.get_class()])
	parent.hide()

func _process(_delta: float) -> void:
	if parent == null:
		queue_free()
	elif follow: global_position = parent.global_position

class_name OtimizadorSprite
extends VisibleOnScreenEnabler2D

var parent: Node2D = null

func _ready() -> void:
	parent = get_parent()
	name = "OPT_" + parent.name
	var grandad: Node = parent.get_parent()
	await grandad.ready
	call_deferred("reparent", grandad)
	enable_node_path = parent.get_path()
	connect("screen_entered", parent.show)
	connect("screen_exited", parent.hide)

func _process(_delta: float) -> void:
	if parent == null:
		queue_free()

extends Node2D

func _ready() -> void:
	get_child(0).connect("animation_finished", queue_free)

extends Area2D

@export var de_camera_x:Camera2D = null#PhantomCamera2D = null
@export var para_camera_y:Camera2D = null #PhantomCamera2D = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if de_camera_x:
			de_camera_x.enabled = false
			#de_camera_x.priority = 0
			#para_camera_y.priority = 1
		if para_camera_y:
			para_camera_y.enabled = true
			#para_camera_y.priority = 2
			#Console._Print("PRIORIDADE")

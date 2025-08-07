extends Node

## Lista de Phantom Cameras na cena
@export var phantom_cameras: Array[PhantomCamera2D]
## Lista de transições de câmera na cena
@export var transicoes: Array[Area2D]

var camera_atual: int = 0

func _ready() -> void:
	for t: Area2D in transicoes:
		var i = t.get_index()
		t.connect("body_entered", MudaCamera.bind(
		 i, i+1 if (i + 1) < (transicoes.size() - 1) else i-1))

func MudaCamera(body, a:int, b:int) -> void:
	print(body)
	if body.is_in_group("Player"):
		print("CAMERA ATUAL: ", camera_atual)
		match camera_atual:
			a:
				camera_atual = b
			b:
				camera_atual = a
	AtualizaCamera()
	
func AtualizaCamera() -> void:
	for c: PhantomCamera2D in phantom_cameras:
		if c.get_index() == camera_atual:
			c.priority = 1
		else: c.priority = 0

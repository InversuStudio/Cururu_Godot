class_name OtimizadorCena
extends VisibleOnScreenNotifier2D

@export var targets:Array[Node2D] = []

func _ready() -> void:
	connect("screen_entered", Aparece) # Conecta funções de entrada/saída
	connect("screen_exited", Some)
	if !is_on_screen():
		Some()

func Aparece() -> void:
	for t:Node2D in targets:
		t.show()
	print(name + " apareceu")

func Some() -> void:
	for t:Node2D in targets:
		t.hide()
	print(name + " sumiu")

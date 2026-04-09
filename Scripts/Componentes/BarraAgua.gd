class_name BarraAgua extends Control

@onready var textura: TextureRect = $Textura

var tamanho:int = 0:
	set(valor):
		tamanho = valor
		step = textura.size.y / tamanho
var valor:int = 0:
	set(val):
		valor = clampi(val, 0, tamanho)
		Update()

var step:float = 0

func Update() -> void:
	var pos:Vector2 = Vector2(0.0, (tamanho - valor) * step)
	var t:Tween = create_tween()
	t.tween_property(textura, "position", pos, .2)
	

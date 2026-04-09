class_name BarraAgua extends Control
@onready var textura: TextureRect = $Textura

var tamanho:int = 10
var valor:int = 0:
	set(val):
		last_val = valor
		valor = clampi(val, 0, tamanho)

var step:float = 0
var last_val = 0

func _ready() -> void:
	GameData.connect("update_magia", func() -> void:
		valor = round(GameData.magia_atual)
		Update()
	)

func Update() -> void:
	print("Step: %s" % step)
	var t:Tween = create_tween()
	var y:float = -1 if valor > last_val else 1
	var pos:Vector2 = textura.position + Vector2(0.0, abs(valor - last_val) * step * y)
	t.tween_property(textura, "position", pos, .2)

class_name Mapa extends PanelContainer

@export var move_speed:float = 2.0
@onready var conteudo: Control = $Conteudo

func _ready() -> void:
	connect("visibility_changed", func() -> void:
		get_tree().paused = visible)
	move_speed *= 128

func _process(delta: float) -> void:
	if !visible: return
	var move:Vector2 = Input.get_vector("esquerda", "direita", "cima", "baixo")
	if move:
		conteudo.position += move * move_speed * delta

func Start() -> void:
	for c:MapaSala in conteudo.get_children():
		c.Start()

extends RigidBody2D

## Item a ser adicionado ao inventário
@export var tipo_item: Inventario.Itens
## Força do impulso aplicado ao item quando spawnado
@export var forca_impulso:float = 10.0

var vel:Vector2 = Vector2.ZERO

func _ready() -> void:
	$AreaGet.connect("body_entered", _on_body_entered)
	# É isso mesmo, Theo. Roubei seu código na cara dura
	var dir:Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, -0.5)).normalized()
	vel = dir * forca_impulso

func _physics_process(_delta: float) -> void:
	vel = vel.move_toward(Vector2.ZERO, 0.1)
	move_and_collide(vel)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Inventario.AddItem(Inventario.ItensString[tipo_item])
		queue_free()

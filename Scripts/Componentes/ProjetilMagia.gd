extends Node2D

## Velocidade do projétil, em m/s
@export var velocidade: Vector2 = Vector2(5.0, 0.0)
@onready var sprite: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	# Checa colisão com HurtBox
	%HitBox.hit.connect(Destroy)
	# Ajusta velocidade
	velocidade *= 128

# Move projétil
func _physics_process(delta: float) -> void:
	global_position += velocidade * delta

# Checa colisão com cenário
func _on_colisao_body_entered(_body: Node2D) -> void:
	Destroy()

# Destrói projétil
func Destroy() -> void:
	velocidade = Vector2.ZERO
	sprite.play("Hit")
	%HitBox.set_deferred("monitoring", false)
	%Timer.start()

func _on_timer_timeout() -> void:
	queue_free()

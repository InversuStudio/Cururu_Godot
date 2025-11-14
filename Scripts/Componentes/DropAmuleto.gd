extends CharacterBody2D

## Item a ser adicionado ao inventário
@export var tipo_item: Inventario.Amuletos
## Impulso aplicado ao spawnar item, em m/s
@export var impulso: Vector2 = Vector2(1.0, 1.0)
## Tempo até desacelerar após impulso
@export var tempo_decel:float = 2.5

@onready var speed:Vector2 = impulso * 128
@onready var decel:float = speed.x / tempo_decel

@export_group("Tela de Item")
## Nome que irá aparecer na tela de item coletado
@export var nome_tela:String = ""
## Descrição que irá aparecer na tela de item coletado
@export_multiline var descricao_tela:String = ""
## Imagem que irá aparecer na tela de item coletado
@export var imagem_tela:Texture2D = null

func _ready() -> void:
	$AreaGet.connect("body_entered", _on_body_entered)
	var rand_x:float = randf_range(-1.0, 1.0)
	speed.x *= rand_x
	speed.y *= -1
	velocity = speed

func _physics_process(delta: float) -> void:
	velocity.y += 128 * delta
	velocity.x = move_toward(velocity.x, 0.0, decel * delta)
	move_and_slide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Inventario.AddAmuleto(Inventario.AmuletosString[tipo_item])
		HUD.AvisoItem(nome_tela, descricao_tela, imagem_tela)
		queue_free()

extends Node2D

@export var intervalo_tiro: float = 2.0
@export var cena_projetil: PackedScene = null

@onready var id: String = str(Mundos.fase_atual) + name

var morreu: bool = false
var pode_atirar: bool = true
var hunting: bool = false

@onready var checa_wall: RayCast2D = %ChecaWall

func _ready() -> void:
	for i: String in Mundos.lista_inimigos:
		if i == id:
			queue_free()
			return
	
	%IntervaloTiro.connect("timeout", func() -> void:
		if !morreu:
			pode_atirar = true
	)

func _physics_process(_delta: float) -> void:
	# Só funciona se estiver caçando
	if !hunting: return
	
	# Revalida linha de visão a cada frame
	if Mundos.player != null:
		# Flip Inimigo
		var dir_player: float = sign(Mundos.player.global_position.x - global_position.x)
		%Flip.scale.x = dir_player
		# Checa parede
		checa_wall.look_at(Mundos.player.global_position)
		if checa_wall.is_colliding():
			if checa_wall.get_collider().is_in_group("Player"):
				pode_atirar = true
			else:
				pode_atirar = false

	if %IntervaloTiro.is_stopped() and pode_atirar:
		%IntervaloTiro.start(intervalo_tiro) #pode_atirar:
		_atirar()

func _on_area_visao_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		hunting = true

func _on_area_visao_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		hunting = false

func _atirar() -> void:
	if cena_projetil == null or morreu or Mundos.player == null:
		return
		
	pode_atirar = false
	var pos:Vector2 = Mundos.player.global_position - Vector2(0, 80)
	var direcao:Vector2 = %PontoDisparo.global_position.direction_to(pos)
	var proj:Area2D = cena_projetil.instantiate()
	proj.global_position = %PontoDisparo.global_position
	get_parent().add_child(proj)
	proj.init(direcao)

func Morte() -> void:
	morreu = true
	pode_atirar = false
	%SomMorte.play()
	Mundos.lista_inimigos.append(id)
	%HurtBox.process_mode = PROCESS_MODE_DISABLED
	%HitBox.process_mode = PROCESS_MODE_DISABLED
	%Sprite.play("morte"); %Sprite.offset = Vector2(0, 0)
	await %Sprite.animation_finished
	queue_free()

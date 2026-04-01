extends Sprite2D

@export var afundamento: float = 12.0
@export var duracao_desce: float = 0.12
@export var duracao_sobe: float = 0.45
@export var velocidade_minima_aterrisagem: float = 50.0

var _posicao_origem: Vector2
var _animando: bool = false
var _estava_caindo: bool = false
var _pos_anterior: Vector2

#@onready var _static_body: StaticBody2D = $StaticBody2D

func _ready() -> void:
	_posicao_origem = position
	_pos_anterior = position

func _physics_process(_delta: float) -> void:
	# Se a plataforma se moveu, arrasta o jogador junto (só pra baixo)
	if _animando:
		var delta_y: float = position.y - _pos_anterior.y
		if delta_y > 0:  # só na descida
			if Mundos.player:
				var dist_x: float = abs(Mundos.player.global_position.x - global_position.x)
				if dist_x < 200.0:
					Mundos.player.global_position.y += delta_y
		_pos_anterior = position
		return

	_pos_anterior = position

	if Mundos.player == null: return

	var vel_y: float = Mundos.player.velocity.y as float
	var caindo_agora: bool = vel_y > velocidade_minima_aterrisagem

	if caindo_agora:
		_estava_caindo = true
		return

	if _estava_caindo and not caindo_agora:
		_estava_caindo = false

		var dist_x: float = abs(Mundos.player.global_position.x - global_position.x)
		var dist_y: float = abs(Mundos.player.global_position.y - global_position.y)

		if dist_x < 200.0 and dist_y < 150.0:
			_animar_elastico()

func _animar_elastico() -> void:
	_animando = true
	_pos_anterior = position
	var tween := create_tween()
	tween.set_parallel(false)

	tween.tween_property(self, "position", _posicao_origem + Vector2(0, afundamento), duracao_desce)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	tween.tween_property(self, "position", _posicao_origem, duracao_sobe)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

	tween.tween_callback(func() -> void: _animando = false)

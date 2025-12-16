@tool
class_name MainCamera extends Camera2D

## Node do Player que a câmera irá seguir
@export var target:Player = null
## Desvio aplicado à posição final
@export var offset_target:Vector2 = Vector2.ZERO
# Desvio horizontal aplicado quando node se move. Serve para mostrar mais do mapa
#@export var look_ahead:float = 0.0
## Velocidade da câmera ao seguir target
@export var speed:float = 5.0
var target_pos:Vector2 = Vector2.ZERO

@export_group("Limite")
## Node ReferenceRect que demarca limite da área que a c^smera pode se mover
@export var limite_camera:ReferenceRect = null

@export_group("Deadzone")
## Habilita deadzone
@export var usa_deadzone:bool = true
## Área da deadzone
@export var deadzone:Vector2:
	set(valor):
		deadzone = valor
		queue_redraw()
## Denfine se mostra área da deadzone durante o jogo
@export var mostrar_deadzone_no_jogo:bool = false

# SCREENSHAKE
var shake_noise:FastNoiseLite = FastNoiseLite.new()
var shake_intensidade:float = 0.0
var shake_tempo_resta:float = 0.0
var shake_ativo:bool = false

func _draw() -> void:
	if mostrar_deadzone_no_jogo or Engine.is_editor_hint():
		draw_rect(Rect2(-deadzone, deadzone * 2.0), Color.BLUE_VIOLET, false, 5.0)

func _ready() -> void:
	await get_tree().physics_frame
	if target:
		global_position = target.global_position + offset
		target_pos = target.global_position + offset
	
	if limite_camera:
		limit_enabled = true
		limit_left = int(limite_camera.global_position.x)
		limit_right = int(limite_camera.global_position.x + limite_camera.size.x)
		limit_top = int(limite_camera.global_position.y)
		limit_bottom = int(limite_camera.global_position.y + limite_camera.size.y)

func Follow(delta:float) -> void:
	global_position = global_position.lerp(target_pos + offset_target, delta * speed)

func _physics_process(delta: float) -> void:
	if target:
		if usa_deadzone:
			if (target.global_position.x > global_position.x + deadzone.x or
			target.global_position.x < global_position.x - deadzone.x or
			target.global_position.y > global_position.y + deadzone.y or
			target.global_position.y < global_position.y - deadzone.y):
				target_pos = target.global_position
				#if !Engine.is_editor_hint():
					#target_pos.x += target.input_move.x * look_ahead * 128.0
		else:
			target_pos = target.global_position
	
		Follow(delta)
		
	if shake_ativo:
		offset = Vector2(
			shake_noise.get_noise_2d(shake_tempo_resta, 0.0) * shake_intensidade,
			shake_noise.get_noise_2d(0.0, shake_tempo_resta) * shake_intensidade
		)
		shake_tempo_resta = max(shake_tempo_resta - delta, 0.0)
		if shake_tempo_resta <= 0.0: shake_ativo = false

func Shake(forca:float, duracao:float = 0.5) -> void:
	#forca_shake = forca
	randomize()
	shake_noise.seed = randi()
	shake_noise.frequency = 2.0
	
	shake_intensidade = forca
	shake_tempo_resta = duracao
	
	shake_ativo = true

func MudaTarget(novo_target:Node2D, novo_offset:Vector2) -> void:
	target = novo_target
	offset_target = novo_offset
	

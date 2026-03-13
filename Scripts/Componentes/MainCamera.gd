class_name MainCamera extends Camera2D

## Node do Player que a câmera irá seguir
@export var target:Node2D = null
## Desvio aplicado à posição final
@export var offset_target:Vector2 = Vector2.ZERO
## Zoom aplicado à câmera
@export var zoom_target:float = 0.8
# Desvio horizontal aplicado quando node se move. Serve para mostrar mais do mapa
@export var look_ahead:float = 0.0
var la:float = 0.0
var usa_look_ahead:bool = true
## Velocidade da câmera ao seguir target
@export var speed:float = 5.0
var target_pos:Vector2 = Vector2.ZERO

@export_group("Limite")
## Node ReferenceRect que demarca limite da área que a c^smera pode se mover
@export var limite_camera:ReferenceRect = null

@onready var deadzone: Area2D = $Deadzone

# SCREENSHAKE
var shake_noise:FastNoiseLite = FastNoiseLite.new()
var shake_intensidade:float = 0.0
var shake_tempo_resta:float = 0.0
var shake_ativo:bool = false

var seguindo:bool = false

@export_group("Olhar")
@export var distancia_a_olhar:float = 3.0
@export var tempo_ate_olhar:float = 1.0
var comando:float = 0.0

@onready var dist:float = distancia_a_olhar * 128

func _ready() -> void:
	look_ahead *= 128
	await get_tree().physics_frame
	if target:
		target_pos = target.global_position + offset
		global_position = target_pos
		deadzone.global_position = target_pos
	
	if limite_camera:
		limit_enabled = true
		limit_left = int(limite_camera.global_position.x)
		limit_right = int(limite_camera.global_position.x + limite_camera.size.x)
		limit_top = int(limite_camera.global_position.y)
		limit_bottom = int(limite_camera.global_position.y + limite_camera.size.y)
	
	deadzone.connect("body_entered", func(_b:Node2D):
		seguindo = false)
	deadzone.connect("body_exited", func(_b:Node2D):
		seguindo = true)

func Follow(delta:float) -> void:
	var look:float = 0.0
	if comando >= tempo_ate_olhar:
		look = -dist
	elif comando <= -tempo_ate_olhar:
		look = dist
	
	
	if usa_look_ahead and seguindo:
		la = lerpf(la, look_ahead * sign(target.input_move.x), .05)
	else:
		la = lerpf(la, 0.0, .05)
	
	global_position = global_position.lerp(target_pos + offset_target + Vector2(
		la, look), delta * speed)
	
	if seguindo:
		deadzone.global_position = deadzone.global_position.lerp(target_pos + offset_target, delta * speed)

func _physics_process(delta: float) -> void:
	if target:
		if seguindo:
			target_pos = target.global_position
			
		Follow(delta)
		
	if shake_ativo:
		offset = Vector2(
			shake_noise.get_noise_2d(shake_tempo_resta, 0.0) * shake_intensidade,
			shake_noise.get_noise_2d(0.0, shake_tempo_resta) * shake_intensidade
		)
		shake_tempo_resta = max(shake_tempo_resta - delta, 0.0)
		if shake_tempo_resta <= 0.0: shake_ativo = false
	
	zoom = zoom.lerp(Vector2(zoom_target, zoom_target), 0.05)

func Shake(forca:float, duracao:float = 0.5) -> void:
	randomize()
	shake_noise.seed = randi()
	shake_noise.frequency = 2.0
	
	shake_intensidade = forca
	shake_tempo_resta = duracao
	
	shake_ativo = true

func MudaTarget(novo_target:Node2D, novo_offset:Vector2) -> void:
	target = novo_target
	offset_target = novo_offset

func MudaZoom(novo_zoom:float = 0.8) -> void:
	zoom_target = novo_zoom

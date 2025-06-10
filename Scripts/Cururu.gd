extends CharacterBody2D

@export_group("Movimento")
## Velocidade de movimento terrestre
@export var speed : float = 0
## Velocidade de movimento aéreo
@export var air_speed : float = 0
## Velocidade de nado
@export var swim_speed : float = 0
## Força do pulo
@export var jump_force : float = 0
## Gravidade da queda
@export var fall_gravity : float = 10
## Gravidade do pulo
@export var jump_gravity : float = 10

@export_group("Componentes")
## Componente Vida
@export var vida : Vida
## Componente HurtBox
@export var hurtbox : HurtBox
## Componente HitBox do ataque corpo a corpo
@export var hitbox_melee : HitBox
## Componente StateMachine
@export var state_machine : StateMachine

@onready var anim: AnimationPlayer = $Anim # Animação

var input_move : float = 0.0 # Input de movimento

func _physics_process(delta: float) -> void:
	# Recebe input de movimento
	input_move = Input.get_axis("esquerda","direita")
	
	if input_move: # Se o input for diferente de 0
		# Espelha o sprite de acordo com o input
		%Cururu.flip_h = true if input_move < 0 else false
	
	# Aplica PHYSICS_PROCESS do StateMachine
	state_machine.FixedUpdate(delta)
	
	move_and_slide()

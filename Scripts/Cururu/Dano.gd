extends State

@export var fall_state: State = null
@export var chao_state: State = null
@export var hurtbox: HurtBox = null

var acabou: bool = false
var counter: float
var target_dir:Vector2

var tempo_hurt:float = 0.0

func _ready() -> void:
	#for h:HurtBox in parent.hurtbox_container:
	#await get_tree().current_scene.ready
	tempo_hurt = hurtbox.tempo_knockback

func Enter() -> void:
	Console._Print(Vector2(1,-1) > Vector2(1,0))
	print("DANO")
	Console._State(name)
	%Anim.play("Dano")
	acabou = false
	await get_tree().create_timer(tempo_hurt).timeout
	acabou = true

func Exit() -> void:
	print("DANO ACABOU")
	#parent.velocity /= 2.0
	parent.pode_mover = true
	parent.pode_dash = true

func FixedUpdate(delta:float) -> State:
	parent.velocity.x = move_toward(parent.velocity.x, 0.0, parent.decel * delta)
	parent.velocity.y = move_toward(parent.velocity.y, 0.0, parent.decel * delta) 
	# Se tempo de stun já acabou
	if acabou:
		# Muda de State
		if parent.is_on_floor():
			return chao_state
		return fall_state
	return null

#func _on_anim_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "Dano":
		#acabou = true

#func _on_hurt_box_counter(knock:float, dir:Vector2) -> void:
	#counter = knock
	#target_dir = dir

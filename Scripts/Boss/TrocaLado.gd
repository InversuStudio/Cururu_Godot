extends State

@export var idle_state:State = null

var terminou:bool = false

func Enter() -> void:
	%Anim.play("Some")
	await %Anim.animation_finished
	%Anim.play("Escondido")
	if parent.scale.x > 0:
		parent.scale.x = -1
		parent.parent_pilares.scale.x = -1
		parent.global_position = parent.flip_node[1].global_position
	else:
		parent.scale.x = 1
		parent.parent_pilares.scale.x = 1
		parent.global_position = parent.flip_node[0].global_position
	await get_tree().create_timer(.5).timeout
	%Anim.play("Surge")
	await %Anim.animation_finished
	terminou = true

func FixedUpdate(_delta : float) -> State:
	if terminou:
		return idle_state
	return null

func Exit() -> void:
	terminou = false

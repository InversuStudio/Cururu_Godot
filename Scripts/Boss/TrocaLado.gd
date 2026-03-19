extends State

@export var idle_state:State = null

var terminou:bool = false

func Enter() -> void:
	%Anim.play("Some")
	%HurtCabeca.set_deferred("monitorable", false)
	%HurtCorpo.set_deferred("monitorable", false)
	var tween_rabo:Tween = create_tween()
	tween_rabo.tween_property(parent.rabo, "global_position",
		parent.pos_rabo[0].global_position, .5)
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
	await get_tree().create_timer(.7).timeout
	%Anim.play("Surge")
	tween_rabo.kill()
	tween_rabo = create_tween()
	tween_rabo.tween_property(parent.rabo, "global_position",
		parent.pos_rabo[1].global_position, .5)
	await %Anim.animation_finished
	%HurtCabeca.set_deferred("monitorable", true)
	%HurtCorpo.set_deferred("monitorable", true)
	terminou = true

func FixedUpdate(_delta : float) -> State:
	if terminou:
		return idle_state
	return null

func Exit() -> void:
	terminou = false

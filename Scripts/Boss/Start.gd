extends State

@export var state_idle:State = null
var inicia_luta:bool = false

func PlayerEntrou(body:Node2D) -> void:
	if body.is_in_group("Player"):
		parent.area_check_player.queue_free()
		parent.area_check_player = null
		%Anim.play("Surge")

func Update(_delta : float) -> State:
	if inicia_luta:
		return state_idle
	return null

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Surge":
		%Anim.play("Grito")
		%BarraVida.show()
		if parent.state_machine.current_state == self:
			if parent.tween:
				parent.tween.kill()
			parent.tween = create_tween()
			parent.tween.tween_property(%BarraVida, "value", %Vida.vida_max, 2.)
	if anim_name == "Grito":
		inicia_luta = true

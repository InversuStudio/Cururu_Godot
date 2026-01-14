extends State

@export var state_idle:State = null
var inicia_luta:bool = false

var player:CharacterBody2D = null

func PlayerEntrou(body:Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player.input_move.x = 0.0
		player.velocity.x = 0.0
		player.pode_mover = false
		parent.area_check_player.queue_free()
		parent.area_check_player = null
		%Anim.play("Surge")
		parent.rabo.show()

func Update(_delta : float) -> State:
	if inicia_luta:
		player.pode_mover = true
		return state_idle
	return null

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Surge" and get_parent().current_state == self:
		%GritoSFX.stream = parent.gritos[0]
		%Anim.play("Grito")
		%BarraVida.show()
		BGM.TocaMusica(parent.musica_luta, -3.)
		if parent.state_machine.current_state == self:
			if parent.tween:
				parent.tween.kill()
			parent.tween = create_tween()
			parent.tween.tween_property(%BarraVida, "value", %VidaBoss.vida_max, 2.)
			
			var tween:Tween = create_tween()
			tween.tween_property(%BarraArmor, "value", %VidaMCorpo.vida_max, 2.5)
	if anim_name == "Grito":
		inicia_luta = true

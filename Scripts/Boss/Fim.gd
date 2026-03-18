extends State

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	#BGM.TocaMusica()
	%ParedeCostas.queue_free()
	%GritoSFX.stream = parent.gritos[0]
	if %Anim.current_animation == "NocauteStart":
		%Anim.play("NocauteEnd")
	else: %Anim.play("NocauteStart")
	%SpriteMain.material.set_shader_parameter("valor", 0.0)
	Mundos.player.pode_mover = false
	Mundos.player.input_move.x = 0.0
	Mundos.player.velocity.x = 0.0
	Mundos.player.pode_ataque = false
	#Mundos.main_camera.usa_look_ahead = true

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if get_parent().current_state != self: return
	match anim_name:
		"NocauteStart":
			%Anim.play("NocauteEnd")
		"NocauteEnd":
			%Anim.play("Final")
			%SpriteCabeca.hide()
			%SpriteCorpo.hide()
		"Final":
			%Anim.play("Idle")
			await get_tree().create_timer(1.5).timeout
			DialogoCMD.IniciaDialogo(parent.dialogo)
			await DialogueManager.dialogue_ended
			LoadCena.Load("res://Cenas/zDemo/FinalDemo.tscn")

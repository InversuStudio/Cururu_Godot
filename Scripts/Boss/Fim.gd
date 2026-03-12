extends State

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	#BGM.TocaMusica()
	%GritoSFX.stream = parent.gritos[0]
	%SpriteCabeca.hide()
	%SpriteCorpo.hide()
	%Anim.play("NocauteEnd")
	%SpriteMain.material.set_shader_parameter("valor", 0.0)
	Mundos.player.pode_mover = false
	Mundos.player.velocity.x = 0.0
	Mundos.player.pode_atacar = false
	await Mundos.player.anim.animation_finished
	Mundos.player.anim.play("Idle")
	Mundos.main_camera.usa_look_ahead = true

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if get_parent().current_state != self: return
	match anim_name:
		"NocauteEnd":
			%Anim.play("Final")
		"Final":
			%Anim.play("Idle")
			await get_tree().create_timer(1.5).timeout
			DialogoCMD.IniciaDialogo(parent.dialogo)
			await DialogueManager.dialogue_ended
			Mundos.CarregaFase(Mundos.NomeFase.FinalDemo)

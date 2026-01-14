extends State

# COMPORTAMENTO AO ENTRAR NO STATE
func Enter() -> void:
	#BGM.TocaMusica()
	%SpriteCabeca.hide()
	%SpriteCorpo.hide()
	%Temp.hide()
	%Anim.play("NocauteEnd")
	%SpriteMain.material.set_shader_parameter("valor", 0.0)
	Mundos.player.velocity.x = 0.0
	Mundos.player.pode_mover = false
	Mundos.player.anim.play("Idle")

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if get_parent().current_state != self: return
	match anim_name:
		"NocauteEnd":
			%Anim.play("Surge")
		"Surge":
			%Anim.play("Final")
		"Final":
			%Anim.play("Idle")
			await get_tree().create_timer(1.0).timeout
			DialogoCMD.IniciaDialogo(parent.dialogo)
			await DialogueManager.dialogue_ended
			Mundos.CarregaFase(Mundos.NomeFase.FinalDemo)

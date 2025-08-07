extends Area2D

var dentro: bool = false
var target: CharacterBody2D = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interagir") and dentro:
		target.vida.RecebeCura(GameData.vida_max)
		GameData.Save()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("ENTROU AREA SAVE")
		target = body
		dentro = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("SAIU AREA SAVE")
		dentro = false

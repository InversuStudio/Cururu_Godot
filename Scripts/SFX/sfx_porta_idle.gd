extends AudioStreamPlayer2D

# 1. Guardamos o arquivo de áudio em uma variável (Recurso)
@onready var som_resource = preload("res://Audio/SFX/AMBIENTE/Porta Miasma Iddle.wav")
@onready var anim_player = %Anim

func _ready():
	# Assim que entrar na sala, verificamos se a animação atual já é o Idle
	if anim_player.current_animation == "Idle":
		tocar_som_loop()

func tocar_som_loop():
	stream = som_resource
	volume_db = 0
	if not playing:
		play()

func parar_som_loop():
	stop()

func _on_anim_animation_finished(anim_name):
	# Verifique se os nomes das animações batem exatamente (Maiúsculas/Minúsculas)
	print("Animação começou: ", anim_name)
	if anim_name == "Abre" or anim_name == "Fecha":
		parar_som_loop()

func _on_anim_animation_started(anim_name):
	if anim_name == "Idle":
		call_deferred("tocar_som_loop")

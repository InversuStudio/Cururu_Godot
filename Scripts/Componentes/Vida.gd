class_name Vida
extends Node

## Valor máximo de pontos de vida
@export var vida_max : int = 0
var vida_atual : int = 0
## Define se chama função de morte quando vida chega a 0
@export var morre:bool = true

@onready var parent:Node2D = get_parent()

# Sinal emite com 2 valores: vida_antiga, vida_atual
signal alterou_vida

func _ready() -> void:
	vida_atual = vida_max
	if parent.is_in_group("Player"):
		# Conecta sinal de aumentar vida_max
		GameData.update_vida_max.connect(func(_o:int):
			vida_max = GameData.vida_max
			#alterou_vida_max.emit()
			RecebeCura())
		
		# Se vida_max não foi configurada, pegar valor próprio
		if GameData.vida_max == 0:
			GameData.vida_max = vida_max
		# Senão, atualiza com valor configurado
		else:
			vida_max = GameData.vida_max
			
		# O mesmo de cima, porém com vida_atual
		if GameData.vida_atual == 0:
			GameData.vida_atual = vida_max
		else:
			vida_atual = GameData.vida_atual
		print("VIDA MAX: " + str(vida_max))

# FUNÇÃO PARA DIMINUIR VIDA
func RecebeDano(dano:int = 1) -> void:
	var vida_antiga:int = vida_atual
	vida_atual -= dano
	vida_atual = clampi(vida_atual, 0, vida_max)
	alterou_vida.emit(vida_atual, vida_antiga)
	# Se vida for zerada, morre
	if vida_atual <= 0 and morre:
		Morre()

# FUNÇÃO PARA AUMENTAR VIDA
func RecebeCura(cura:int = 1) -> void:
	var vida_antiga:int = vida_atual
	vida_atual += cura
	vida_atual = clampi(vida_atual, 0, vida_max)
	alterou_vida.emit(vida_atual, vida_antiga)

# FUNÇÃO DE MORRER
func Morre():
	print(parent.name + " morreu.")
	if parent.has_method("Morte"):
		parent.Morte()
	else:
		var tween:Tween = create_tween()
		tween.tween_property(parent, "modulate", Color(.0,.0,.0,.0), .5)
		await tween.finished
		parent.queue_free()

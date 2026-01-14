extends Control

@onready var pagina:int = 0;

@onready var telas:Array[Node2D] = [
	$Tela0,
	$Tela1,
	$Tela2,
	$Tela3,
	$Tela4,
	$Tela5,
	$Tela6,
	$Tela7,
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Continuar.grab_focus()
	for tela in telas:
		tela.visible = false
	telas[0].visible = true

func _on_continuar_pressed() -> void:
	pagina += 1
	
	if pagina <= 2:
		for i:int in range(pagina + 1):
			telas[i].visible = true
	
	if pagina > 2 and pagina <= 7:
		for i:int in range(3):
			telas[i].visible = false
		for i:int in range(3, pagina + 1):
			telas[i].visible = true
	elif pagina > 7:
		Mundos.CarregaFase(Mundos.NomeFase.TUTORIAL_1)

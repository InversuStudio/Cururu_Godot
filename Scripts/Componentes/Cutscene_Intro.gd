extends Control

@onready var pagina:int = 0;

@onready var telas:Array[Sprite2D] = [
	%Tela0,
	%Tela1,
	%Tela2,
	%Tela3,
	%Tela4,
	%Tela5,
	%Tela6,
	%Tela7,
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.connect("tipo_input_mudou", UpdateBTN)
	#%Continuar.grab_focus()
	UpdateBTN()
	for tela:Sprite2D in telas:
		if tela.get_index() > 0:
			tela.modulate.a = 0.0
		#tela.visible = false
	#telas[0].visible = true

func UpdateBTN() -> void:
	%BTN.text = "[img]%s[/img]" % GameData.GetUiButtonImage("ui_accept")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		Next()

func Next() -> void:
	pagina += 1
	
	if pagina <= 2:
		for i:int in range(pagina + 1):
			Revela(telas[i])
			#telas[i].visible = true
	
	if pagina > 2 and pagina <= 7:
		for i:int in range(3):
			Revela(telas[i], false)
			#telas[i].visible = false
		for i:int in range(3, pagina + 1):
			Revela(telas[i])
			#telas[i].visible = true
	elif pagina > 7:
		LoadCena.Load("res://Cenas/aTutorial/Tutorial_1.tscn")

func Revela(tela:Sprite2D, visivel:bool = true) -> void:
	var c:Color = Color.WHITE if visivel else Color.TRANSPARENT
	var t:Tween = create_tween()
	t.tween_property(tela, "modulate", c, .2)
	

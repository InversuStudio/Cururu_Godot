extends RichTextLabel

func _ready() -> void:
	GameData.connect("tipo_input_mudou", UpdateBTN)
	UpdateBTN()

func UpdateBTN() -> void:
	text = "[img]%s[/img]" % GameData.GetUiButtonImage("ui_accept")

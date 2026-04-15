@tool
class_name MapaSala extends Control

@export var fase:StringName = ""
@export_tool_button("Update Tamanho") var update_sala = UpdateSala

func _ready() -> void:
	LoadCena.connect("fase_mudou", func() -> void:
		var f:PackedStringArray = fase.split("/")
		if f[f.size() - 1] == Mundos.fase_atual + ".tscn":
			show()
			%In.show()
		else: %In.hide()
	)
	%In.hide()

func Start() -> void:
	var lista_fase:PackedStringArray = fase.split("/")
	var nome:StringName = lista_fase[lista_fase.size() - 1]
	if Mundos.fases_visitadas.size() > 0:
		for nome_lista:StringName in Mundos.fases_visitadas:
			var new:StringName = nome.replace(".tscn", "")
			if nome_lista == new:
				print("TO MOSTRANDO")
				show()
			else: hide()
	else:
		hide()

func UpdateSala() -> void:
	if !Engine.is_editor_hint(): return
	if ResourceLoader.exists(fase):
		var fase_sample:PackedScene = ResourceLoader.load(fase)
		if fase_sample:
			var instance:Node2D = fase_sample.instantiate()
			var limit:ReferenceRect = null
			for c:Node in instance.get_children(true):
				if c is ReferenceRect:
					limit = c
					break
			if limit:
				size = limit.size / 40
			instance.queue_free()

extends Node

func Print(text:Variant) -> void:
	var console:DebugConsole = get_tree().get_first_node_in_group("Console")
	if console:
		console.AddTexto(str(text))

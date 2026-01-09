extends Button

@export var max_font_size: int = 22
@export var min_font_size: int = 10

var ultimo_texto: String = ""

func _process(_delta: float) -> void:
	# Verifica se o texto do botão mudou
	if text != ultimo_texto:
		ultimo_texto = text
		ajustar_tamanho_fonte()

func ajustar_tamanho_fonte() -> void:
	var tamanho_atual = max_font_size
	
	# Pega a fonte que o botão está usando atualmente
	var font = get_theme_font("font")
	
	# Mede o tamanho do texto com a fonte atual
	# Consideramos o tamanho do botão menos as margens internas (padding)
	var largura_disponivel = size.x - 20 # 20 é uma margem de segurança
	
	# Enquanto o texto for mais largo que o botão, diminui a fonte
	while font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, tamanho_atual).x > largura_disponivel and tamanho_atual > min_font_size:
		tamanho_atual -= 1
	
	# Aplica o novo tamanho
	add_theme_font_size_override("font_size", tamanho_atual)

extends RichTextLabel

# Variáveis de configuração (aparecem no Inspetor)
@export var max_font_size: int = 45
@export var min_font_size: int = 30

# Variável de controle para saber se o texto mudou
var ultimo_texto: String = ""

func _process(_delta: float) -> void:
	# Como não existe o sinal 'text_changed', checamos se o texto mudou no _process
	if text != ultimo_texto:
		ultimo_texto = text
		ajustar_tamanho_fonte()

func ajustar_tamanho_fonte() -> void:
	var tamanho_atual = max_font_size
	
	# Aplica o tamanho máximo inicial
	add_theme_font_size_override("normal_font_size", tamanho_atual)
	
	# Força a Godot a processar o texto para podermos medir a altura
	force_update_transform()
	
	# Se o conteúdo for maior que a altura da caixa, diminui a fonte em loop
	# IMPORTANTE: O nó precisa ter um 'Size' definido no Layout para isso funcionar
	while get_content_height() > size.y and tamanho_atual > min_font_size:
		tamanho_atual -= 1
		add_theme_font_size_override("normal_font_size", tamanho_atual)
		force_update_transform()

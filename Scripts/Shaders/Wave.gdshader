shader_type canvas_item;

/* Velocidade da onda (lenta e orgânica) */
uniform float wave_speed : hint_range(0.0, 5.0) = 0.8;

/* Intensidade da onda (pixels reais) */
uniform float wave_strength : hint_range(0.0, 10.0) = 1.2;

/* Frequência horizontal */
uniform float wave_frequency : hint_range(0.0, 10.0) = 2.0;

/* Porção do topo afetada (percentual da altura) */
uniform float top_influence : hint_range(0.0, 1.0) = 0.15;

void vertex() {
	/* Máscara no topo via UV */
	float top_mask = smoothstep(
		top_influence,
		0.0,
		UV.y
	);

	/* Wave horizontal suave */
	float wave = sin(
		TIME * wave_speed +
		UV.x * wave_frequency * 6.28318
	);

	/* Deslocamento vertical contido */
	VERTEX.y += wave * wave_strength * top_mask;
}

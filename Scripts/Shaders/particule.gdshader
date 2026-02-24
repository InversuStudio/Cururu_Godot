ader_type canvas_item;

// ===================================================
// TELA
// ===================================================
uniform vec2 dimensions = vec2(1920.0, 1080.0);

// ===================================================
// GRID
// ===================================================
uniform float rows = 24.0;
uniform float columns = 8.0;

// ===================================================
// CONTROLE DE TEMPO
// ===================================================
uniform float speed_scale : hint_range(0.0, 3.0, 0.01) = 1.0;

// ===================================================
// VELOCIDADE E GRAVIDADE
// ===================================================
uniform vec2 velocity = vec2(0.0, -0.3);   // movimento base
uniform float gravity : hint_range(-3.0, 3.0, 0.01) = -0.4;

// ===================================================
// TAMANHO
// ===================================================
uniform float size_min : hint_range(0.05, 1.0, 0.01) = 0.25;
uniform float size_max : hint_range(0.05, 1.0, 0.01) = 0.6;

// ===================================================
// ONDA
// ===================================================
uniform float wave_strength : hint_range(0.0, 2.0, 0.01) = 0.6;
uniform float wave_speed : hint_range(0.0, 5.0, 0.01) = 1.0;
uniform float wave_rotation : hint_range(-1.0, 1.0, 0.01) = 0.5;

// ===================================================
// COR
// ===================================================
uniform vec4 base_color  : source_color = vec4(0.7, 0.9, 1.0, 1.0);
uniform vec4 depth_color : source_color = vec4(0.2, 0.4, 0.6, 1.0);
uniform float color_mix  : hint_range(0.0, 1.0, 0.01) = 0.6;
uniform float alpha : hint_range(0.0, 1.0, 0.01) = 0.8;

// ===================================================
// TEXTURA
// ===================================================
uniform sampler2D particle_texture : source_color, filter_nearest_mipmap;

// ===================================================
// FRAGMENT
// ===================================================
void fragment() {

	float time = TIME * speed_scale;

	// -----------------------------------------------
	// IDs da célula
	// -----------------------------------------------
	float row_id = floor(UV.y * rows);
	float col_id = floor(UV.x * columns);

	// -----------------------------------------------
	// Hash estável
	// -----------------------------------------------
	float seed = fract(sin(row_id * 12.9898 + col_id * 78.233) * 43758.5453);

	// -----------------------------------------------
	// GRAVIDADE (aceleração no tempo)
	// s = vt + 1/2 a t²
	// -----------------------------------------------
	float gravity_offset = 0.5 * gravity * time * time;

	// -----------------------------------------------
	// DESLOCAMENTO GLOBAL
	// -----------------------------------------------
	vec2 motion =
		velocity * time +
		vec2(0.0, gravity_offset);

	// -----------------------------------------------
	// ONDA
	// -----------------------------------------------
	float wave =
		sin(time * wave_speed + seed * 6.28318) *
		wave_strength;

	// -----------------------------------------------
	// UV LOCAL DA PARTÍCULA
	// -----------------------------------------------
	vec2 local_uv;
	local_uv.x = fract((UV.x + motion.x + wave / columns) * columns);
	local_uv.y = fract((UV.y + motion.y) * rows);

	vec2 uv = local_uv * 2.0 - 1.0;

	// -----------------------------------------------
	// ASPECT RATIO
	// -----------------------------------------------
	uv.x *= (dimensions.x / dimensions.y) * (rows / columns);

	// -----------------------------------------------
	// TAMANHO
	// -----------------------------------------------
	float size = mix(size_min, size_max, seed);

	// -----------------------------------------------
	// ROTAÇÃO
	// -----------------------------------------------
	float angle = (seed + wave) * wave_rotation * PI;
	float s = sin(angle);
	float c = cos(angle);

	uv = mat2(
		vec2(c, s),
		vec2(-s, c)
	) * uv;

	// -----------------------------------------------
	// COR POR PROFUNDIDADE
	// -----------------------------------------------
	vec4 color = mix(base_color, depth_color, seed * color_mix);
	color.a *= alpha;

	// -----------------------------------------------
	// TEXTURA
	// -----------------------------------------------
	vec2 tex_uv = (uv / size + 1.0) * 0.5;

	float inside =
		step(0.0, tex_uv.x) * step(tex_uv.x, 1.0) *
		step(0.0, tex_uv.y) * step(tex_uv.y, 1.0);

	vec4 particle = texture(particle_texture, tex_uv) * color;
	particle.a *= inside;

	// -----------------------------------------------
	// COMPOSIÇÃO FINAL
	// -----------------------------------------------
	COLOR.rgb = mix(COLOR.rgb, particle.rgb, particle.a);
	COLOR.a = max(COLOR.a, particle.a);
}

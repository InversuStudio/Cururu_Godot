shader_type canvas_item;

// =========================
// DEFORMAÇÃO DA SUPERFÍCIE
// =========================
uniform float wave_amplitude = 8.0;   // intensidade da onda (pixels)
uniform float wave_frequency = 0.04;  // densidade horizontal
uniform float wave_speed = 1.0;       // velocidade

// =========================
// ÁREA AFETADA (TOPO DO TILE)
// =========================
uniform float surface_ratio = 0.15;   // porcentagem do tile (0 = topo)
uniform float surface_softness = 0.08;

void vertex() {

    // Máscara vertical baseada no UV
    // UV.y = 0 topo | UV.y = 1 fundo
    float mask =
        1.0 - smoothstep(
            surface_ratio,
            surface_ratio + surface_softness,
            UV.y
        );

    // Onda horizontal contínua
    float wave =
        sin(
            VERTEX.x * wave_frequency +
            TIME * wave_speed
        ) * wave_amplitude;

    // Aplica deformação SOMENTE no topo
    VERTEX.y += wave * mask;
}

void fragment() {
    // Mantém sprite + self_modulate sem alterações
    COLOR = texture(TEXTURE, UV) * COLOR;
}

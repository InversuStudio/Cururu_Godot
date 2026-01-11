shader_type canvas_item;

// Required in Godot 4 for screen sampling
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

/*
    =========================
    CONTROLES DE ORIENTAÇÃO
    =========================
*/

// Espelha o efeito no eixo horizontal (X)
uniform bool flip_horizontal = false;

// Espelha o efeito no eixo vertical (Y)
uniform bool flip_vertical = false;

/*
    =========================
    CONTROLES PRINCIPAIS
    =========================
*/

uniform float angle = -0.3;
uniform float position = -0.2;
uniform float spread : hint_range(0.0, 1.0) = 0.5;
uniform float cutoff : hint_range(-1.0, 1.0) = 0.1;
uniform float falloff : hint_range(0.0, 1.0) = 0.2;
uniform float edge_fade : hint_range(0.0, 1.0) = 0.15;

uniform float speed = 1.0;
uniform float ray1_density = 8.0;
uniform float ray2_density = 30.0;
uniform float ray2_intensity : hint_range(0.0, 1.0) = 0.3;

uniform vec4 color : source_color = vec4(1.0, 0.9, 0.65, 0.8);

uniform bool hdr = false;
uniform float seed = 5.0;

/*
    =========================
    FUNÇÕES DE RUÍDO
    =========================
*/

float random(vec2 _uv) {
    return fract(
        sin(dot(_uv.xy, vec2(12.9898, 78.233))) *
        43758.5453123
    );
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

/*
    =========================
    FUNÇÕES AUXILIARES
    =========================
*/

mat2 rotate(float _angle) {
    return mat2(
        vec2(cos(_angle), -sin(_angle)),
        vec2(sin(_angle),  cos(_angle))
    );
}

vec4 screen(vec4 base, vec4 blend) {
    return 1.0 - (1.0 - base) * (1.0 - blend);
}

/*
    =========================
    FRAGMENT
    =========================
*/

void fragment() {

    /*
        UV base com opção de espelhamento
    */
    vec2 uv = UV;

    if (flip_horizontal) {
        uv.x = 1.0 - uv.x;
    }

    if (flip_vertical) {
        uv.y = 1.0 - uv.y;
    }

    /*
        Transformação principal dos UVs
    */
    vec2 transformed_uv =
        (rotate(angle) * (uv - position)) /
        ((uv.y + spread) - (uv.y * spread));

    /*
        Camada 1 – raios largos (fundo)
    */
    vec2 ray1 = vec2(
        transformed_uv.x * ray1_density +
        sin(TIME * 0.1 * speed) * (ray1_density * 0.2) +
        seed,
        1.0
    );

    /*
        Camada 2 – raios finos (frente)
    */
    vec2 ray2 = vec2(
        transformed_uv.x * ray2_density +
        sin(TIME * 0.2 * speed) * (ray1_density * 0.2) +
        seed,
        1.0
    );

    /*
        Corte lateral
    */
    float cut = step(cutoff, transformed_uv.x) *
                step(cutoff, 1.0 - transformed_uv.x);

    ray1 *= cut;
    ray2 *= cut;

    /*
        Combinação das camadas
    */
    float rays;
    if (hdr) {
        rays = noise(ray1) + (noise(ray2) * ray2_intensity);
    } else {
        rays = clamp(
            noise(ray1) + (noise(ray2) * ray2_intensity),
            0.0,
            1.0
        );
    }

    /*
        Fade vertical e nas bordas
    */
    rays *= smoothstep(0.0, falloff, 1.0 - uv.y);
    rays *= smoothstep(cutoff, edge_fade + cutoff, transformed_uv.x);
    rays *= smoothstep(cutoff, edge_fade + cutoff, 1.0 - transformed_uv.x);

    /*
        Coloração
    */
    vec3 shine = vec3(rays) * color.rgb;

    /*
        Blend Screen com o fundo
    */
    shine = screen(
        texture(SCREEN_TEXTURE, SCREEN_UV),
        vec4(shine, 1.0)
    ).rgb;

    COLOR = vec4(shine, rays * color.a);
}
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

/*
    =========================
    CONTROLES DE ORIENTAÇÃO
    =========================
*/

uniform bool flip_horizontal = false;
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

float random(vec2 p) {
    p = fract(p * vec2(123.34, 345.45));
    p += dot(p, p + 34.345);
    return fract(p.x * p.y);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

/*
    =========================
    FUNÇÕES AUXILIARES
    =========================
*/

mat2 rotate(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(
        vec2(c, -s),
        vec2(s,  c)
    );
}

vec3 screen_blend(vec3 base, vec3 blend) {
    return 1.0 - (1.0 - base) * (1.0 - blend);
}

/*
    =========================
    FRAGMENT
    =========================
*/

void fragment() {
    vec2 uv = UV;

    /*
        Espelhamento sem blocos extras complexos
    */
    uv.x = flip_horizontal ? (1.0 - uv.x) : uv.x;
    uv.y = flip_vertical ? (1.0 - uv.y) : uv.y;

    /*
        Pré-cálculos
    */
    float t1 = sin(TIME * 0.1 * speed);
    float t2 = sin(TIME * 0.2 * speed);

    float denom = (uv.y + spread) - (uv.y * spread);
    vec2 transformed_uv = (rotate(angle) * (uv - vec2(position))) / denom;

    /*
        Raios
    */
    float ray1_x =
        transformed_uv.x * ray1_density +
        t1 * (ray1_density * 0.2) +
        seed;

    float ray2_x =
        transformed_uv.x * ray2_density +
        t2 * (ray1_density * 0.2) +
        seed;

    /*
        Corte lateral
    */
    float cut = step(cutoff, transformed_uv.x) *
                step(cutoff, 1.0 - transformed_uv.x);

    /*
        Noise combinado
    */
    float rays = noise(vec2(ray1_x, 1.0)) +
                 noise(vec2(ray2_x, 1.0)) * ray2_intensity;

    rays *= cut;

    /*
        Clamp condicional simplificado
    */
    if (!hdr) {
        rays = clamp(rays, 0.0, 1.0);
    }

    /*
        Fade vertical e de borda
    */
    float fade_vertical = smoothstep(0.0, falloff, 1.0 - uv.y);
    float fade_left = smoothstep(cutoff, edge_fade + cutoff, transformed_uv.x);
    float fade_right = smoothstep(cutoff, edge_fade + cutoff, 1.0 - transformed_uv.x);

    rays *= fade_vertical * fade_left * fade_right;

    /*
        Cor
    */
    vec3 shine = vec3(rays) * color.rgb;

    /*
        Screen blend com fundo
    */
    vec3 screen_col = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
    shine = screen_blend(screen_col, shine);

    COLOR = vec4(shine, rays * color.a);
}
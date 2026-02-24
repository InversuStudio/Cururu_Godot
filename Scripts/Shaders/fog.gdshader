shader_type canvas_item;

uniform vec4 fog_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float density = 0.4;
uniform float speed = 0.04;
uniform float scale = 2.5;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;

    for (int i = 0; i < 5; i++) {
        value += noise(p * frequency) * amplitude;
        frequency *= 2.0;
        amplitude *= 0.5;
    }

    return value;
}

void fragment() {
    vec2 uv = UV * scale;

    // Fluxos diferentes quebram linhas retas
    uv += vec2(
        TIME * speed,
        sin(TIME * 0.7) * speed * 0.5
    );

    float n = fbm(uv);

    // Curva suave de densidade
    float alpha = smoothstep(0.3, 1.0, n) * density;

    COLOR = vec4(fog_color.rgb, alpha);
}

shader_type canvas_item;

uniform vec4 fog_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float density : hint_range(0.0, 1.0) = 0.4;
uniform float speed : hint_range(0.0, 1.0) = 0.04;
uniform float scale : hint_range(0.1, 10.0) = 2.5;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;

    value += noise(p) * 0.5;
    p *= 2.0;

    value += noise(p) * 0.25;
    p *= 2.0;

    value += noise(p) * 0.125;
    p *= 2.0;

    value += noise(p) * 0.0625;

    return value;
}

void fragment() {
    float t = TIME * speed;

    vec2 uv = UV * scale;
    uv += vec2(t, sin(t * 12.0) * 0.02);

    float n = fbm(uv);
    float alpha = smoothstep(0.35, 0.9, n) * density;

    COLOR = vec4(fog_color.rgb, alpha);
}

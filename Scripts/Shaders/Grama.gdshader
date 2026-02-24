shader_type canvas_item;
render_mode blend_mix;

uniform float speed = 1.0;
uniform float minStrength : hint_range(0.0, 1.0) = 0.05;
uniform float maxStrength : hint_range(0.0, 1.0) = 0.1;
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float heightOffset : hint_range(0.0, 1.0);

uniform bool flip_wind = false; // ✅ Checkbox real
uniform float offset = 0.0;

float getWind(float time, float uv_y){
    float diff = maxStrength - minStrength;
    float strength = (minStrength + abs(sin(time / interval)) * diff) * strengthScale;
    float mask = max(0.0, (1.0 - uv_y) - heightOffset);
    float wave = sin(time + uv_y * detail);
    return wave * strength * mask;
}

void vertex() {
    float time = TIME * speed + offset;
    float wind = getWind(time, UV.y);

    if (flip_wind) {
        wind = -wind;
    }

    VERTEX.x += wind;
}
shader_type canvas_item;

uniform float fade_size : hint_range(0.0, 0.5) = 0.15;

void fragment() {
	float top = smoothstep(0.0, fade_size, UV.y);
	float bottom = smoothstep(0.0, fade_size, 1.0 - UV.y);
	
	float alpha = top * bottom;
	
	COLOR = vec4(0.0, 0.0, 0.0, 1.0 - alpha);
}
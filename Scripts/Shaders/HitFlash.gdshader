shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0f);
uniform float valor : hint_range(0.0f, 1.0f) = 0.0f;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec4 mixed_color = mix(original_color, flash_color, valor);
	
	COLOR = mixed_color;
	COLOR.a = original_color.a;
}

shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;

void fragment() {
	COLOR = vec4(texture(screen_tex, SCREEN_UV).rgb, texture(TEXTURE, UV).a);
}

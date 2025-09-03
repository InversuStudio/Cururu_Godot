shader_type canvas_item;

void vertex() {
	VERTEX.y += sin(TIME * 5.0 + VERTEX.x) * 1.2;
}
shader_type canvas_item;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	if (col.r > 0.80 && col.g > 0.80 && col.b > 0.80) {
		col.a = 0.0;
	}
	COLOR = col;
}
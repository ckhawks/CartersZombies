shader_type canvas_item;

uniform vec4 new_color: source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 curr_color = texture(TEXTURE, UV);
	if (curr_color.rba == vec3(0, 0, 1) && curr_color.g > 0.0) {
		COLOR.rgb = new_color.rgb * curr_color.g;
	}
}

shader_type canvas_item;

/// Radius in UV space from center (0.5, 0.5); square quad inscribed circle ~0.5.
uniform float clip_radius : hint_range(0.25, 0.5) = 0.44;

void fragment() {
	vec2 p = UV - vec2(0.5);
	float d = length(p);
	float edge = smoothstep(clip_radius + 0.012, clip_radius - 0.012, d);
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= edge;
}

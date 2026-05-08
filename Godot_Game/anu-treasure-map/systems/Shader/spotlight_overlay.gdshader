shader_type canvas_item;

uniform vec2 center_uv = vec2(0.5, 0.5);
uniform vec2 rect_half_size = vec2(0.15, 0.06);
uniform float feather = 0.06;
uniform float aspect_ratio = 1.7778;

void fragment() {
	vec2 d = (UV - center_uv) * vec2(aspect_ratio, 1.0);
	// Rect SDF — distance from edge of rectangle (negative inside)
	vec2 q = abs(d) - rect_half_size;
	float dist = length(max(q, 0.0)) + min(max(q.x, q.y), 0.0);
	// 0 = inside spotlight (clear), 1 = outside (dark)
	float darkness = smoothstep(-feather * 0.4, feather, dist);
	vec3 dark_col = vec3(0.04, 0.05, 0.14);
	COLOR = vec4(dark_col, clamp(darkness * 0.76, 0.0, 1.0));
}

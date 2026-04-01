shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 15.0) = 0.0;

const float GOLDEN_ANGLE = 2.39996;
const int SAMPLES = 24;

void fragment() {
	if (blur_amount < 0.01) {
		// 如果模糊度很小，直接输出原图，不再使用 return
		COLOR = texture(TEXTURE, UV);
	} else {
		// 否则执行模糊计算
		vec4 color = vec4(0.0);
		float total = 0.0;

		for (int i = 0; i < SAMPLES; i++) {
			float fi = float(i);
			float angle = fi * GOLDEN_ANGLE;
			float radius = sqrt(fi / float(SAMPLES)) * blur_amount;
			vec2 offset = vec2(cos(angle), sin(angle)) * radius * TEXTURE_PIXEL_SIZE;
			float weight = 1.0 - fi / float(SAMPLES);
			color += texture(TEXTURE, UV + offset) * weight;
			total += weight;
		}

		COLOR = color / total;
	}
}
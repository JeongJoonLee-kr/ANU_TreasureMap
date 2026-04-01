shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float lod: hint_range(0.0, 5.0) = 2.5; 
uniform vec4 tint_color : source_color = vec4(0.0, 0.0, 0.0, 0.0); // 新增：独立的变暗/染色层

void fragment(){
    vec4 blur_color = textureLod(screen_texture, SCREEN_UV, lod);
    
  
    vec3 blended_color = mix(blur_color.rgb, tint_color.rgb, tint_color.a);
    
    
    COLOR = vec4(blended_color, COLOR.a);
}
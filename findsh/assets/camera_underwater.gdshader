shader_type spatial;
// Add "depth_test_disabled" or ensure it sorts at the absolute front
render_mode unshaded, fog_disabled, depth_test_disabled;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec2 uv = SCREEN_UV;
    uv.x += sin(SCREEN_UV.y * 2.5 + TIME) * 0.008; 
    uv.y += sin(SCREEN_UV.x * 2.5 + TIME) * 0.008;

    ALBEDO = texture(screen_texture, uv).rgb;
}
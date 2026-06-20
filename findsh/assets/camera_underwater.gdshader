shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    // Calculate UV coordinates
	vec2 uv = SCREEN_UV;
    // Offset the UV coordinates based on a sine wave
    uv.x += sin(SCREEN_UV.y * 2.5 + TIME) * 0.008; // Adjust the frequency and amplitude as needed
    uv.y += sin(SCREEN_UV.x * 2.5 + TIME) * 0.008;

    // Sample the texture using the modified UV coordinates
    ALBEDO = texture(screen_texture, uv).rgb;
}
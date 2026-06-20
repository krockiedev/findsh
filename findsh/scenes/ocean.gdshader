shader_type spatial;
render_mode blend_add, depth_draw_never, unshaded, cull_disabled;

uniform vec4 ray_color : source_color = vec4(0.2, 0.6, 0.8, 0.4);
uniform float speed : hint_range(0.0, 5.0) = 0.5;
uniform float ray_density : hint_range(1.0, 20.0) = 5.0;

// Simple procedural noise to simulate moving water curtains
float generate_rays(vec2 uv, float time) {
    float ray1 = sin(uv.x * ray_density + time * speed) * 0.5 + 0.5;
    float ray2 = cos(uv.x * (ray_density * 1.4) - time * (speed * 0.7)) * 0.5 + 0.5;
    return pow(ray1 * ray2, 2.0); // Sharpen the ray boundaries
}

void fragment() {
    // Scroll the rays along the mesh UVs
    float ray_pattern = generate_rays(UV, TIME);
    
    // Fade the rays out cleanly at the top and bottom edges of the mesh
    float edge_fade = sin(UV.y * 3.14159);
    
    // Apply final composition
    ALBEDO = ray_color.rgb * ray_pattern;
    ALPHA = ray_color.a * ray_pattern * edge_fade;
}
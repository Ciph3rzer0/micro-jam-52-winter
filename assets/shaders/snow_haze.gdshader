shader_type spatial;
render_mode unshaded, cull_back;

// Parameters
uniform vec3 snow_color : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 haze_color : source_color = vec3(0.5, 0.6, 0.7);
uniform float snow_speed = 2.0;
uniform float wind_strength = 0.2;
uniform float snow_density = 0.6; // Higher is less density (threshold)
uniform float haze_density = 0.5;

// Simple pseudo-random function
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// Simple noise function
float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(p + vec2(0, 0));
    float b = hash(p + vec2(1, 0));
    float c = hash(p + vec2(0, 1));
    float d = hash(p + vec2(1, 1));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Function to generate a snow layer
float snow_layer(vec2 uv, float scale, float speed_mult, float time) {
    float w = sin(time * 0.5 + uv.y * 2.0) * wind_strength; // Wind sway
    vec2 movement = vec2(w * 0.5, speed_mult * time);
    vec2 p = uv * scale + movement;
    
    // Sample noise
    float n = noise(p);
    
    // Threshold to create flakes
    n = step(snow_density, n);
    
    return n;
}

void fragment() {
    float time = TIME * snow_speed;
    vec2 uv = UV;
    
    // Generate multiple layers of snow for depth
    float layer1 = snow_layer(uv, 15.0, 1.0, time);
    float layer2 = snow_layer(uv + vec2(5.2, 1.3), 25.0, 0.8, time);
    float layer3 = snow_layer(uv + vec2(2.4, 4.8), 10.0, 1.2, time);
    
    // Combine layers
    float snow = max(layer1, max(layer2, layer3));
    
    // Haze/Background
    // Create a subtle gradient or noise for the haze
    float haze_noise = noise(uv * 3.0 + vec2(time * 0.1, 0.0));
    vec3 bg_color = mix(haze_color, haze_color * 1.2, haze_noise * 0.2);
    
    // Mix snow on top of haze
    vec3 final_color = mix(bg_color, snow_color, snow);
    
    ALBEDO = final_color;
    
    // Optional: make it translucent if needed, but for a window backdrop, opaque is usually fine.
    ALPHA = 0.7; 
}

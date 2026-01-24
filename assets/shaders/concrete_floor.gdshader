shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 line_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform vec4 splotch_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);

varying vec3 world_vertex_coords;

void vertex() {
	world_vertex_coords = VERTEX;
}

// Function to generate a random float from a vec2
float rand(vec2 n) {
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

// Function to generate noise
float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	
	float n = mix(mix(rand(i + vec2(0.0, 0.0)), rand(i + vec2(1.0, 0.0)), f.x),
				mix(rand(i + vec2(0.0, 1.0)), rand(i + vec2(1.0, 1.0)), f.x), f.y);
	return n;
}

// Function to create a concrete texture
vec3 concrete(vec2 p) {
	float total = 0.0;
	float persistence = 0.5;
	int octaves = 4;
	float freq = 2.0;
	float amp = 0.5;
	
	for(int i = 0; i < octaves; i++) {
		total += noise(p * freq) * amp;
		freq *= 2.0;
		amp *= persistence;
	}
	
	total = pow(total, 0.8);
	return mix(base_color.rgb, splotch_color.rgb, total);
}

void fragment() {
	// Use world coordinates for the texture and grid
	vec2 uv = world_vertex_coords.xz;

	// --- Concrete Texture ---
	vec3 color = concrete(uv * 0.5);

	// --- Grid Lines ---
	// Use fwidth to get anti-aliased lines
	vec2 grid = abs(fract(uv) - 0.5);
	float line_width = 0.02;
	float line = smoothstep(line_width, line_width + 0.01, min(grid.x, grid.y));
	
	// Make grid lines darker
	color = mix(line_color.rgb, color, line);

	ALBEDO = color;
	ROUGHNESS = 0.8;
	METALLIC = 0.1;
}

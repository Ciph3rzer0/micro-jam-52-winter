shader_type spatial;

// Conveyor belt shader with moving chevron pattern

// --- Configuration ---
uniform vec4 belt_color : source_color = vec4(0.05, 0.05, 0.05, 1.0); // Dark gray/black for the belt
uniform vec4 line_color : source_color = vec4(0.4, 0.4, 0.4, 1.0);   // Gray for the tread lines
uniform float speed : hint_range(0.0, 5.0) = 1.0;                     // Speed of the belt movement
uniform float line_thickness : hint_range(0.0, 0.1) = 0.02;           // Thickness of the tread lines
uniform float chevron_frequency : hint_range(1.0, 20.0) = 5.0;        // How many chevrons appear on the belt


void fragment() {
	// --- Animation ---
	// Create a new UV set that scrolls vertically over time.
	vec2 moving_uv = UV;
	moving_uv.y += TIME * speed;

	// --- Pattern ---
	// Use fract() to make the pattern repeat.
	// The core idea is to create diagonal lines that mirror at the halfway point (uv.x = 0.5).
	// abs(UV.x - 0.5) gives us a value that is 0.5 at the edges and 0.0 in the middle.
	// Multiplying by 2 scales this to be 1.0 at the edges and 0.0 in the middle.
	float mirrored_x = abs(UV.x - 0.5) * 2.0;
	
	// Create the repeating chevron pattern by combining the x and y coordinates.
	float pattern = fract((moving_uv.y - mirrored_x) * chevron_frequency);
	
	// --- Drawing ---
	// Use smoothstep to draw the anti-aliased lines based on the desired thickness.
	float line = smoothstep(0.5 - line_thickness, 0.5 + line_thickness, pattern);
	
	// Mix the belt and line colors based on the pattern.
	vec3 final_color = mix(line_color.rgb, belt_color.rgb, line);

	// --- Output ---
	ALBEDO = final_color;
	ROUGHNESS = 0.8; // Belts are usually not very shiny
	METALLIC = 0.1;
}

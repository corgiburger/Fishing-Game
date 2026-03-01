
shader_type canvas_item;

// --- Motion (same as your version) ---
uniform float amplitude_px : hint_range(0.0, 64.0) = 2.0;     // vertical displacement in pixels
uniform float period : hint_range(0.05, 5.0) = 2.2;           // seconds for one sine cycle
uniform float travel_speed_cols : hint_range(1.0, 512.0) = 96.0; // columns per second left->right
uniform bool wrap_vertical = false;

// --- Brightness ripple (new) ---
// How strong the highlight is (e.g., 0.0 = off, 0.1 = +10% at the center of the band)
uniform float highlight_strength : hint_range(0.0, 0.5) = 0.08;
// The visual width of the moving highlight band, in columns (larger = wider/softer)
uniform float highlight_width_cols : hint_range(0.5, 64.0) = 6.0;
// How fast the brightness band sweeps left->right, in columns per second
uniform float highlight_speed_cols : hint_range(1.0, 1024.0) = 120.0;

void fragment() {
    // --- Column index so every pixel in a column shares motion/brightness ---
    float col_index = floor(UV.x / TEXTURE_PIXEL_SIZE.x + 1e-4);

    // --- Left->right phase delay for the vertical sine motion ---
    float delay_s = col_index / travel_speed_cols;
    float t = TIME - delay_s;
    float wave = sin((t / period) * 6.283185); // 2π

    // --- Apply vertical offset (UV space) ---
    float offset_uv_y = amplitude_px * wave * TEXTURE_PIXEL_SIZE.y;
    vec2 uv2 = UV + vec2(0.0, offset_uv_y);

    // --- Wrap or clamp the vertical sampling ---
    if (wrap_vertical) {
        uv2.y = fract(uv2.y);
    } else {
        uv2.y = clamp(uv2.y, 0.0, 1.0);
    }

    // --- Base texture sample ---
    vec4 tex = texture(TEXTURE, uv2);

    // --- Brightness ripple (soft moving highlight band) ---
    // Total number of columns in the texture
    float total_cols = 1.0 / TEXTURE_PIXEL_SIZE.x;

    // Center of the highlight band, advancing left->right and wrapping
    float band_center = mod(TIME * highlight_speed_cols, total_cols);

    // Smallest wrapped distance between this column and the band center
    float dx = abs(col_index - band_center);
    dx = min(dx, total_cols - dx);

    // Gaussian falloff for a smooth band
    float sigma = max(0.1, highlight_width_cols); // avoid divide-by-zero
    float band = exp(-0.5 * (dx * dx) / (sigma * sigma));

    // Final brightness factor (1.0 = no change)
    float brightness = 1.0 + highlight_strength * band;

    COLOR = tex * COLOR * brightness;
}

shader_type canvas_item;
uniform vec2 stretch = vec2(1.0);
uniform float radius: hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float brightness: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float density: hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float opacity: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform vec4 static_color: source_color = vec4(1.0);

void fragment() {
    float random_noise = fract(sin(dot(UV, vec2(12.9898, 78.233) * TIME)) * 43758.5453);

    vec2 stretched_uv = vec2((UV.x - 0.5) * stretch.x + 0.5, (UV.y - 0.5) * stretch.y + 0.5);
    float circle = 1.0 - smoothstep(0.0, radius, distance(stretched_uv, vec2(0.5)));
    if(random_noise < density){
        COLOR = vec4(vec3(static_color.rgb) * brightness, circle * opacity);
    }
    else {
        COLOR.a = 0.0;
    }
}
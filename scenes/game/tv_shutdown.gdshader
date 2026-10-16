shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float speed = 1.0;
uniform float progress: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float smoothness = 0.1;
uniform float flash_radius: hint_range(0.0, 1.0, 0.01) = 0.15;
uniform vec4 flash_color: source_color = vec4(1.0);
uniform vec4 off_color: source_color = vec4(vec3(0.0), 1.0);
uniform bool monitor_filter = false;

void fragment() {
	//float progress = fract(TIME);
	
	if(progress == 0.0 && !monitor_filter){
		discard;
	}
	
	float angle = -0.5 + 0.8 * progress;
	
	float fade = 0.25 * (sin(PI * angle * speed + cos(PI * angle * speed)) + 1.0);
	vec2 fade_border = vec2(8.5 * (fade - 0.4), fade);
	
	vec2 stretched_uv = vec2((SCREEN_UV.x - 0.5) * clamp((1.0 + 2.0 * fade_border.x) ,1.0, 2.0) + 0.5, (SCREEN_UV.y - 0.5) * (1.0 + 2.0 * fade_border.y) + 0.5);
	vec4 background = mix(texture(screen_texture, stretched_uv), vec4(1.0), 2.0 * progress);
	
	if(UV.y <= 0.5 && UV.y > fade_border.y){
		vec4 gradient = vec4(smoothstep(fade_border.y, fade_border.y + smoothness, UV.y));
		COLOR = mix(off_color, flash_color, gradient) * background;
	}
	else if(UV.y > 0.5 && UV.y < (1.0 - fade_border.y)){
		vec4 gradient = vec4(1.0 - smoothstep(1.0 - fade_border.y - smoothness, 1.0 - fade_border.y, UV.y));
		COLOR = mix(off_color, flash_color, gradient) * background;
	}
	else{
		COLOR = off_color;
	}
	
	if(UV.x <= 0.5 && UV.x > fade_border.x){
			vec4 gradient = vec4(smoothstep(fade_border.x, fade_border.x + smoothness, UV.x));
			COLOR = mix(off_color, COLOR, gradient);
	}
	else if(UV.x > 0.5 && UV.x < (1.0 - fade_border.x)){
			vec4 gradient = vec4(1.0 - smoothstep(1.0 - fade_border.x - smoothness, 1.0 - fade_border.x, UV.x));
			COLOR = mix(off_color, COLOR, gradient);
	}
	else{
		COLOR = off_color;
	}
	
	float flash = flash_radius * (cos(PI * angle * speed + sin(PI * angle * speed)));
	
	if(distance(UV, vec2(0.5)) < flash){
		vec4 circle = vec4(1.0 - smoothstep(0.0, flash, distance(UV, vec2(0.5)))) * 2.0;
		COLOR += circle * flash_color;
	}
}
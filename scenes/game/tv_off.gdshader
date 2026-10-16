shader_type canvas_item;
uniform float speed = 1.0;
uniform float progress  : hint_range(0, 1) = 0.0;
uniform float smoothness = 0.1;
uniform float flash_radius = 0.15;

void fragment() {
    float angle = -0.5 + 0.8 * progress;

    // float fade = 0.25 * (sin(TIME * speed + cos(TIME * speed)) + 1.0);
    float fade = 0.25 * (sin(PI * angle * speed + cos(PI * angle * speed)) + 1.0);
    vec2 fade_border = vec2(8.5 * (fade - 0.4), fade);

    if(UV.y <= 0.5 && UV.y > fade_border.y){
        COLOR = vec4(vec3(smoothstep(fade_border.y, fade_border.y + smoothness, UV.y)), 1.0);
    } 
    else if (UV.y > 0.5 && UV.y < (1.0 - fade_border.y)){
        COLOR = vec4(vec3(1.0 - smoothstep(1.0 - fade_border.y - smoothness, 1.0 - fade_border.y, UV.y)), 1.0);
    }

    if(UV.x <= 0.5 && UV.x < fade_border.x){
        COLOR = vec4(vec3(smoothstep(fade_border.x - smoothness, fade_border.x, UV.x)), 1.0);
    } 
    else if (UV.x > 0.5 && UV.x > (1.0 - fade_border.x)){
        COLOR= vec4(vec3(1.0 - smoothstep(1.0 - fade_border.x, 1.0 - fade_border.x + smoothness, UV.x)), 1.0);
    }

    //float flash = flash_radius * (cos(TIME * speed + sin(TIME * speed)));
    float flash = flash_radius * (cos(PI * angle * speed + sin(PI * angle * speed)));

    if(distance(UV, vec2(0.5)) < flash){
        vec4 circle = vec4(vec3(1.0 - smoothstep(0.0, flash, distance(UV, vec2(0.5)))) * 2.0, 1.0);
        COLOR += circle;
    }
}
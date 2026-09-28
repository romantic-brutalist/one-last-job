shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1.0);

void fragment() {
    vec3 color = vec3(0.0);
    vec2 bl = step(vec2(0.6,0.0),UV) + (vec2(1)-step(vec2(0.4,0.0),UV));
    vec2 bl2 = step(vec2(0.025,0.05),UV) * (vec2(1)-step(vec2(0.975,0.95),UV));
    //bl = vec2(1) - bl;
    //bl = bl * bl2;
    float pct1 = 1.0 - bl.x * bl.y;
    float pct2 = bl2.x * bl2.y;
    color = vec3((1.0-pct1) * (1.0-pct2));

    COLOR = vec4(color, 1.0) * tint;
}











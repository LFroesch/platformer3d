shader_type spatial;

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap;
uniform float scroll_speed = 0.5;

void fragment() {
    vec2 base_uv = UV;
    base_uv.y += TIME * scroll_speed;
    ALBEDO = texture(texture_albedo, base_uv).rgb;
}
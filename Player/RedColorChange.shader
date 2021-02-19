shader_type canvas_item;

uniform vec4 new_color : COLOR;//= vec4(0, 0, 1.0, 1);

void fragment() {
    vec4 curr_color = texture(TEXTURE,UV); // Get current color of pixel

    if ((curr_color.r > 0.01 && curr_color.a > 0.2) && (curr_color.g < 0.6) && (curr_color.b < 0.8)){
        vec4 rep_color = new_color * vec4(curr_color.r, curr_color.r, curr_color.r, 1);
        COLOR = rep_color;
    }else{
        COLOR = curr_color;
    }
}
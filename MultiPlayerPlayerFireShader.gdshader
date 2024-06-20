shader_type canvas_item;

uniform float rotation = 0.0;

vec2 rotateUV(vec2 uv, vec2 pivot) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	uv -= pivot;
	return vec2(
		cosa * uv.x - sina * uv.y,
		cosa * uv.y + sina * uv.x 
	) + pivot;
}

//void vertex() {
	//VERTEX = rotateUV(VERTEX, 0.5/TEXTURE_PIXEL_SIZE);
	//VERTEX.y = VERTEX.y + (TIME/5.1);
//}


void fragment() {
  COLOR = vec4(UV.y, 0.3, 0.4, 0.7);
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

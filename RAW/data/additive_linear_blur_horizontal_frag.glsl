/**********************************************************
A verry simple horizontal additive linear blur with 
variable radius in one dimension.

author: barn
version 140731

**********************************************************/

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform int radius; // must be positive
uniform float offsetPerPixel;
uniform float coveringPower; // use this value to adjust the blur part


varying vec4 vertTexCoord;

void main(void) {

    vec4 sum = vec4(0,0,0,0);
    int divisor = 0;

	for( int offset = -radius ; offset <= radius; ++offset)
	{
		int weight = radius - abs(offset) + 1;
		sum += weight * texture2D(texture, vertTexCoord.st + vec2( offset * offsetPerPixel, 0));
		divisor += weight;
	}
    
    gl_FragColor = texture2D(texture, vertTexCoord.st) + coveringPower * (sum / divisor);
}
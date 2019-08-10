#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


varying float noiseVal;

void main() {
    
    vec4 color = vec4(0,0,0,1);

    color.r = noiseVal;
    color.g = noiseVal*2;
    color.b = noiseVal*3;
    
    gl_FragColor = color;

}

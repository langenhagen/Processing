#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;

varying float noiseVal;

void main() {
    
    vec4 color = vec4(1,1,1,1);

    gl_FragColor = vertColor;
}

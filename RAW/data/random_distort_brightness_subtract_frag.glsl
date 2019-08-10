/**********************************************************
A verry simple random brightness distort of a texture.

author: barn
version 140807

**********************************************************/

#define PROCESSING_TEXTURE_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform float variance;
uniform float seed;

varying vec4 vertTexCoord;


// Some weirdo pseudo-random function found on the internet.
// Hey, it kinda works =D !
float rand(vec2 v){
    return fract(sin(dot(v.xy ,vec2(12.9898,78.233))) * 43758.5453);
}



void main() {
    
    vec4 color = texture2D(texture, vertTexCoord.st);
    vec4 rand = vec4( (rand( vertTexCoord.st + seed) - 1 ) * variance);
    gl_FragColor = color + rand;
}

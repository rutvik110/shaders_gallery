// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform vec3 color2;

vec2 rotatePoint(vec2 pt,vec2 center,float angle){
    float sinAngle=sin(angle);
    float cosAngle=cos(angle);
    pt-=center;
    vec2 r=vec2(1.);
    r.x=pt.x*cosAngle-pt.y*sinAngle;
    r.y=pt.x*sinAngle+pt.y*cosAngle;
    r+=center;
    return r;
}

void main(){
    // inputs
    float tiles=5.;
    float speed=5.;
    float direction=.8;
    float warpScale=1.;
    float warpTiling=0.;
    vec3 color1=vec3(.086,.193,1.);
    vec3 color2=vec3(.044,.895,1.);
    
    // normalized vector value 0.-1.0
    vec2 uv=gl_FragCoord.xy/u_resolution.xy;
    
    vec2 uv2=rotatePoint(uv.xy,vec2(.5,.5),direction*2.*PI);
    
    uv2.x+=sin(uv2.y*warpTiling*PI*2.)*warpScale+u_time/speed;
    uv2.x*=tiles;
    
    float st=floor(fract(uv2.x)+.5);
    
    vec3 color=mix(color1,color2,st);
    
    gl_FragColor=vec4(color,1.);
}


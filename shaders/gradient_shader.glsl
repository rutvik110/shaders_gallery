uniform float u_time;
#define PI 3.14159265359
uniform float speed;

uniform vec2 u_resolution;

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    
    uv.x*=u_resolution.x/u_resolution.y;
    
    vec3 color=vec3(0.);
    color=vec3(uv.x,uv.y,abs(sin(u_time)));
    
    return vec4(color,1.);
}
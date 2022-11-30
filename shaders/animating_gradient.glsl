
uniform float u_time;
uniform vec2 u_resolution;

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    
    vec2 st=fragCoord.xy/u_resolution.xy;
    st.x*=u_resolution.x/u_resolution.y;
    
    vec3 color=vec3(0.);
    color=.5+.5*cos(u_time*1.2+st.xyy+vec3(0,2,4));
    color.g=0.;
    
    return vec4(color,1.);
}
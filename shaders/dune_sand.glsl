// Sand Desert - https://www.shadertoy.com/view/WdjXRR
// Generative dune landscape
// Exploring procedural painting
// Licensed under hippie love conspiracy
// Leon Denise (ponk) 2019.03.15
// Using code from:
// Inigo Quilez (shadertoy.com/view/Xds3zN)
// Morgan McGuire (shadertoy.com/view/4dS3Wd)

const float PI=3.1415;
const vec3 yellow=vec3(.976,.870,.482);
const float seedScale=6.;
const float timeSpeed=.1;
uniform vec2 iResolution;
uniform sampler2D image;
uniform float iTime;

mat2 rot(float a){float c=cos(a),s=sin(a);return mat2(c,-s,s,c);}
float random(in vec2 st){return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);}
float hash(float n){return fract(sin(n)*1e4);}
float noise(in vec2 st){
    vec2 i=floor(st);
    vec2 f=fract(st);
    float a=random(i);
    float b=random(i+vec2(1.,0.));
    float c=random(i+vec2(0.,1.));
    float d=random(i+vec2(1.,1.));
    vec2 u=f*f*(3.-2.*f);
    return mix(a,b,u.x)+
    (c-a)*u.y*(1.-u.x)+
    (d-b)*u.x*u.y;
}
float noise(vec3 x){
    const vec3 step=vec3(110,241,171);
    vec3 i=floor(x);
    vec3 f=fract(x);
    float n=dot(i,step);
    vec3 u=f*f*(3.-2.*f);
    return mix(mix(mix(hash(n+dot(step,vec3(0,0,0))),hash(n+dot(step,vec3(1,0,0))),u.x),
    mix(hash(n+dot(step,vec3(0,1,0))),hash(n+dot(step,vec3(1,1,0))),u.x),u.y),
    mix(mix(hash(n+dot(step,vec3(0,0,1))),hash(n+dot(step,vec3(1,0,1))),u.x),
    mix(hash(n+dot(step,vec3(0,1,1))),hash(n+dot(step,vec3(1,1,1))),u.x),u.y),u.z);
}
float fbm(vec3 p){
    float amplitude=.5;
    float result=0.;
    for(float index=0.;index<=3.;++index){
        result+=noise(p/amplitude)*amplitude;
        p.y-=.01;
        amplitude/=2.;
    }
    return result;
}

vec4 fragment(vec2 uv,vec2 fragCoord){
    vec3 color=vec3(1.,1.,1.);
    vec2 p=(uv.xy-.5*iResolution.xy)/iResolution.y;
    vec2 seed=p*max(.1,uv.y+.2)*seedScale;
    float timeline=mod(iTime*timeSpeed,1000.);
    float salty=fbm(vec3(seed+noise(seed*2.),timeline*.2));
    float a=salty*PI*5.+noise(seed*4.)*.5;
    vec2 unit=1./iResolution.xy;
    color.rgb=yellow*abs(sin(a))*1.5;
    color*=.1+.9*random(uv+fract(timeline));
    uv+=vec2(cos(a),sin(a))*unit;
    uv-=normalize(p)*unit;
    vec3 frame=texture(image,uv).rgb;
    frame.r+=.002;
    float blend=iTime;
    color.rgb=frame*blend+(1.-blend)*color.rgb;
    
    return vec4(color,uv.x);
}
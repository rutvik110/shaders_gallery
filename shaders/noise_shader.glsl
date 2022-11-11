// Based on https://www.shadertoy.com/view/lt33zn
uniform float time;
uniform vec2 scale;
uniform float amplifier;
uniform vec2 frequency;
uniform sampler2D image;

const mat3 m=mat3(
    0.,.80,.60,
    -.80,.36,-.48,
    -.60,-.48,.64
);

float hash(float n){
    return fract(sin(n)*43758.5453);
}

float noise(in vec3 x){
    vec3 p=floor(x);
    vec3 f=fract(x);
    
    f=f*f*(3.-2.*f);
    
    float n=p.x+p.y*57.+113.*p.z;
    
    float res=mix(mix(mix(hash(n+0.),hash(n+1.),f.x),
    mix(hash(n+57.),hash(n+58.),f.x),f.y),
    mix(mix(hash(n+113.),hash(n+114.),f.x),
    mix(hash(n+170.),hash(n+171.),f.x),f.y),f.z);
    return res;
}

float fbm(vec3 p){
    float f=.5000*noise(p);p=m*p*2.02;
    f+=.2500*noise(p);p=m*p*2.03;
    f+=.1250*noise(p);p=m*p*2.01;
    f+=.0625*noise(p);p=m*p*2.05;
    f+=.0625/2.*noise(p);p=m*p*2.02;
    f+=.0625/4.*noise(p);
    return f;
}

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    vec3 position=scale.y*vec3(uv,0.)-time*(1.,1.,1.)*.1;
    float noise=fbm(position);
    
    vec3 value=(.5+.5*sin(noise*vec3(frequency.x,frequency.y,1.)*scale.x))/scale.x;
    value*=amplifier;
    
    vec3 color=texture(image,.02*value.xy+fragCoord.xy/resolution.xy).rgb;
    return vec4(color,1.);
}
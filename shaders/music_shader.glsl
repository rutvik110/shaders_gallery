// Inspired and modified version from https://www.learnwithjason.dev/build-your-own-audio-visualization-in-a-shader

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform float u_vol;

#define PI 3.14
float getBPMVis(float bpm){
  
  // this function can be found graphed out here :https://www.desmos.com/calculator/rx86e6ymw7
  float bps=60./bpm;// beats per second
  float bpmVis=tan((u_time*PI)/bps);
  // multiply it by PI so that tan has a regular spike every 1 instead of PI
  // divide by the beat per second so there are that many spikes per second
  bpmVis=clamp(bpmVis,0.,10.);
  // tan goes to infinity so lets clamp it at 10
  bpmVis=abs(bpmVis)/20.;
  // tan goes up and down but we only want it to go up
  // (so it looks like a spike) so we take the absolute value
  // dividing by 20 makes the tan function more spiking than smoothly going
  // up and down, check out the desmos link to see what i mean
  
  return bpmVis;
}

// https://math.stackexchange.com/questions/2491494/does-there-exist-a-smooth-approximation-of-x-bmod-y
// found this equation and converted it to GLSL, usually e is supposed to be squared but in this case I like the way it looks as 0 //idk
float smoothMod(float x,float y,float e){
  float top=cos(PI*(x/y))*sin(PI*(x/y));
  float bot=pow(sin(PI*(x/y)),2.);
  float at=atan(top/bot);
  return y*(1./2.)-(1./PI)*at;
}
// Repeat around the origin by a fixed angle.
// For easier use, num of repetitions is use to specify the angle.
vec2 modPolar(vec2 p,float repetitions){
  float angle=2.*3.14/repetitions;
  float a=atan(p.y,p.x)+angle/2.;
  float r=length(p);
  //float c = floor(a/angle);
  a=smoothMod(a,angle,033323231231561.9)-angle/2.;
  //a = mix(a,)
  vec2 p2=vec2(cos(a),sin(a))*r;
  
  //p = mix(p,p2, pow(angle - abs(angle-(angle/2.) ) /angle , 2.) );
  
  return p2;
}

// http://www.iquilezles.org/www/articles/palettes/palettes.htm
// to see this function graphed out go to: https://www.desmos.com/calculator/rz7abjujdj
vec3 cosPalette(float t,vec3 brightness,vec3 contrast,vec3 osc,vec3 phase)
{
  
  return brightness+contrast*cos(6.28318*(osc*t+phase));
}
void pR(inout vec2 p,float a){
  p=cos(a)*p+sin(a)*vec2(p.y,-p.x);
}

// main is a reserved function that is going to be called first
vec4 fragment(in vec2 uv,in vec2 fragCoord){
  
  float time=u_time/5.;//slow down time
  
  uv=-1.+2.*uv;
  
  uv.x*=u_resolution.x/u_resolution.y;
  
  pR(uv,time);
  uv=modPolar(uv,20.+(10.*abs(sin(time))));
  uv.x+=sin(time);
  pR(uv,-time);
  float radius=length(uv*10.);
  
  float rings=sin(u_vol*.1-radius);
  
  float angle=sin(atan(uv.x,uv.y)+time);
  
  float swirly=sin(rings+cos(angle)+time);
  
  float beat=getBPMVis(30.);
  
  vec3 brightness=vec3(mix(.7,.1,(sin(time+length(uv*20.)+beat)+1.)/2.));
  vec3 contrast=vec3(.15);
  vec3 osc=vec3(.5,1.,0);
  vec3 phase=vec3(.4,.9,.2);
  
  vec3 palette=cosPalette(angle+swirly+rings,brightness,contrast,osc,phase);
  
  vec4 color=vec4(palette,1);
  
  return color;
}

//Inspiration https://twitter.com/gamemakerstk/status/1590778079118782464
// Created by - Rutvik_Tak
// shadertoy - https://www.shadertoy.com/view/csfXDn

uniform vec2 u_resolution;
uniform sampler2D image;

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    // Normalized pixel coordinates (from 0 to 1)
    uv=fragCoord.xy/u_resolution.xy;
    
    // Output to screen
    
    vec4 mycolor=vec4(uv.xyx,1.);
    
    //vec4 color = texture( iChannel0, uv.xy );
    
    vec4 bitRateColor=vec4(sin(mycolor.x*700.)*.3,cos(mycolor.y*700.)*.3,1.,1.);
    vec2 res=u_resolution.xy/3.;
    vec2 pos=floor(uv*res)/res;
    if(max(abs(pos.x-.5),abs(pos.y-.5))>.5){
        return vec4(0.);
    }
    
    vec4 imagePixel=texture(image,pos.xy);
    
    vec4 imagetopixelcolor=vec4(bitRateColor.xy,imagePixel.x,imagePixel.x);
    
    float grayScaleValue=(imagetopixelcolor.x+imagetopixelcolor.y+imagetopixelcolor.z)/3.;
    
    return vec4(vec3(grayScaleValue*2.).xy,.25,1.);
    
}

// //v1
// void mainImage(out vec4 fragColor,in vec2 fragCoord)
// {
    //         // Normalized pixel coordinates (from 0 to 1)
    //         vec2 uv=fragCoord/iResolution.xy;
    
    //         // Output to screen
    
    //         vec4 mycolor=vec4(uv.xyx,1.);
    
    //         //vec4 color = texture( iChannel0, uv.xy );
    
    //         vec4 bitRateColor=vec4(sin(mycolor.x*iTime)*.5,cos(mycolor.y*iTime)*.5,1.,1.);
    
    //         vec4 imagePixel=texture(iChannel0,uv.xy);
    
    //         vec4 imagetopixelcolor=vec4(bitRateColor.xy,imagePixel.x,imagePixel.x);
    
    //         float grayScaleValue=(imagetopixelcolor.x+imagetopixelcolor.y+imagetopixelcolor.z)/3.;
    
    //         fragColor=vec4(vec3(grayScaleValue),1.);
    
// }

// //v2
// //one with pixelation and color scale at blue
// void mainImage(out vec4 fragColor,in vec2 fragCoord)
// {
    //         // Normalized pixel coordinates (from 0 to 1)
    //         vec2 uv=fragCoord/iResolution.xy;
    
    //         // Output to screen
    
    //         vec4 mycolor=vec4(uv.xyx,1.);
    
    //         //vec4 color = texture( iChannel0, uv.xy );
    
    //         vec4 bitRateColor=vec4(sin(mycolor.x*iTime)*.5,cos(mycolor.y*iTime)*.5,1.,1.);
    //         vec2 res=iResolution.xy/3.;
    //         vec2 pos=floor(uv*res)/res;
    //         if(max(abs(pos.x-.5),abs(pos.y-.5))>.5){
        //                 fragColor=vec4(0.);
    //         }
    
    //         vec4 imagePixel=texture(iChannel0,pos.xy);
    
    //         vec4 imagetopixelcolor=vec4(bitRateColor.xy,imagePixel.x,imagePixel.x);
    
    //         float grayScaleValue=(imagetopixelcolor.x+imagetopixelcolor.y+imagetopixelcolor.z)/3.;
    
    //         fragColor=vec4(vec3(grayScaleValue).xy,.25,1.);
    
// }

// v3

// void mainImage(out vec4 fragColor,in vec2 fragCoord)
// {
    //     // Normalized pixel coordinates (from 0 to 1)
    //     vec2 uv=fragCoord/iResolution.xy;
    
    //     // Output to screen
    
    //     vec4 mycolor=vec4(uv.xyx,1.);
    
    //     //vec4 color = texture( iChannel0, uv.xy );
    
    //     vec4 bitRateColor=vec4(sin(mycolor.x*700.)*.3,cos(mycolor.y*700.)*.3,1.,1.);
    //     vec2 res=iResolution.xy/3.;
    //     vec2 pos=floor(uv*res)/res;
    //     if(max(abs(pos.x-.5),abs(pos.y-.5))>.5){
        //         fragColor=vec4(0.);
    //     }
    
    //     vec4 imagePixel=texture(iChannel0,pos.xy);
    
    //     vec4 imagetopixelcolor=vec4(bitRateColor.xy,imagePixel.x,imagePixel.x);
    
    //     float grayScaleValue=(imagetopixelcolor.x+imagetopixelcolor.y+imagetopixelcolor.z)/3.;
    
    //     fragColor=vec4(vec3(grayScaleValue).xy,.25,1.);
    
// }
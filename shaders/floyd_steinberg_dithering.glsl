
uniform vec2 iResolution;
uniform sampler2D image;

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    
    // Normalized pixel coordinates (from 0 to 1)
    // vec2uv=fragCoord/iResolution.xy;
    
    // Output to screen
    
    vec4 mycolor=vec4(uv.xyx,1.);
    
    //vec4 color = texture( iChannel0, uv.xy );
    
    vec4 bitRateColor=vec4(sin(mycolor.x*700.)*.3,cos(mycolor.y*700.)*.3,1.,1.);
    vec2 res=iResolution.xy/3.;
    vec2 pos=floor(uv*res)/res;
    if(max(abs(pos.x-.5),abs(pos.y-.5))>.5){
        return vec4(0.);
    }
    
    vec4 imagePixel=texture(image,pos.xy);
    float colorFactor=8.;
    
    //vec4 imagetopixelcolor=vec4(bitRateColor.xy,imagePixel.x,imagePixel.x);
    
    // float grayScaleValue=(imagetopixelcolor.x+imagetopixelcolor.y+imagetopixelcolor.z)/3.;
    // float newR=round(colorFactor*imagePixel.r)*1./colorFactor;
    // float newG=round(colorFactor*imagePixel.g)*1./colorFactor;
    // float newB=round(colorFactor*imagePixel.b)*1./colorFactor;//step(0.5,imagePixel.b);
    float newRMultiplier=1.;
    if(fract(colorFactor*imagePixel.r)>=.5){
        newRMultiplier=colorFactor*imagePixel.r+(1.-fract(colorFactor*imagePixel.r));
    }else{
        newRMultiplier=colorFactor*imagePixel.r-fract(colorFactor*imagePixel.r);
    }
    float newGMultiplier=1.;
    if(fract(colorFactor*imagePixel.g)>=.5){
        newGMultiplier=colorFactor*imagePixel.g+(1.-fract(colorFactor*imagePixel.g));
    }else{
        newGMultiplier=colorFactor*imagePixel.g-fract(colorFactor*imagePixel.g);
    }
    float newBMultiplier=1.;
    if(fract(colorFactor*imagePixel.b)>=.5){
        newBMultiplier=colorFactor*imagePixel.b+(1.-fract(colorFactor*imagePixel.b));
    }else{
        newBMultiplier=colorFactor*imagePixel.b-fract(colorFactor*imagePixel.b);
    }
    
    float newR=newRMultiplier*1./colorFactor;
    float newG=newGMultiplier*1./colorFactor;
    float newB=newBMultiplier*1./colorFactor;
    
    float errR=imagePixel.r-newR;
    float errG=imagePixel.g-newG;
    float errB=imagePixel.b-newB;
    
    // pixels[x + 1][y    ] := pixels[x + 1][y    ] + quant_error × 7 / 16
    //  pixels[x - 1][y + 1] := pixels[x - 1][y + 1] + quant_error × 3 / 16
    //  pixels[x    ][y + 1] := pixels[x    ][y + 1] + quant_error × 5 / 16
    //  pixels[x + 1][y + 1] := pixels[x + 1][y + 1] + quant_error × 1 / 16
    
    vec3 filteredColor=vec3(sin(newR),sin(newB),tan(newB));
    return vec4(filteredColor,1.);
    
}
uniform float pixelSize;
uniform sampler2D image;

vec4 pixel(vec2 pos,vec2 res){
    pos=floor(pos*res)/res;
    if(max(abs(pos.x-.5),abs(pos.y-.5))>.5){
        return vec4(0.);
    }
    return texture(image,pos.xy).rgba;
}

vec4 fragment(in vec2 uv,in vec2 fragCoord){
    return pixel(uv,resolution.xy/pixelSize);
}

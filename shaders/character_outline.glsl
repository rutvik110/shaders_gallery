uniform vec2 imageResolution;
uniform float lineThickness;
uniform vec4 lineColor;
uniform sampler2D image;
uniform float u_time;

vec4 getColor(vec2 uv){
    
    uv.x*=imageResolution.x/imageResolution.y;
    
    return vec4(uv.x,uv.y,abs(sin(u_time)),1.);
}

bool check_bounds(vec4 a,vec4 b,vec4 c,vec4 d,vec4 e,vec4 f,vec4 g,vec4 h){
    if(a.a<.5)return true;
    if(b.a<.5)return true;
    if(c.a<.5)return true;
    if(d.a<.5)return true;
    if(e.a<.5)return true;
    if(f.a<.5)return true;
    if(g.a<.5)return true;
    if(h.a<.5)return true;
    return false;
}

vec4 fragment(vec2 uv,vec2 fragCoord){
    vec2 TEXTURE_PIXEL_SIZE=vec2(1.)/imageResolution;
    
    vec2 size=TEXTURE_PIXEL_SIZE*lineThickness;
    vec4 color=texture(image,uv);
    
    if(color.a>.5){
        if(check_bounds(
                texture(image,uv+vec2(-size.x,-size.y)),// top left
                texture(image,uv+vec2(0,-size.y)),// top center
                texture(image,uv+vec2(size.x,-size.y)),// top right
                texture(image,uv+vec2(-size.x,0)),// center left
                texture(image,uv+vec2(size.x,0)),// center right
                texture(image,uv+vec2(-size.x,size.y)),// bottom left
                texture(image,uv+vec2(0,size.y)),// bottom center
                texture(image,uv+vec2(size.x,size.y))// bottom right
            )){
                color=getColor(uv);
            }
            // Ensure that the bounding box is outlined if required.
            if(uv.x<size.x)color=getColor(uv);
            if(uv.y<size.y)color=getColor(uv);
            if(uv.y>1.-size.y)color=getColor(uv);
            if(uv.x>1.-size.x)color=getColor(uv);
        }
        
        return color;
    }
    
    
#pragma header

#define iChannel0 bitmap

uniform float iTime;
uniform float strength;
uniform float angle;

const int samples = 50;

vec4 dirBlur(vec2 uv, vec2 angle)
{
    vec3 acc = vec3(0);
    
    const float delta = 2.0 / float(samples);
    for(float i = -1.0; i <= 1.0; i += delta)
    {
        acc += texture2D(iChannel0, uv - vec2(angle.x * i, angle.y * i)).rgb * delta * .5;
    }
    
    return vec4(acc, 1.0);  
}


void main()
{
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;

    vec2 uv = fragCoord / iResolution.xy;
    
    float r = radians(angle);
    vec2 direction = vec2(sin(r), cos(r));
    
    gl_FragColor = dirBlur(uv, strength*direction);
    //fragColor = texture(iChannel0, uv);
}

//https://www.shadertoy.com/view/NltSD4
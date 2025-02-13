#pragma header

uniform float binaryIntensity;
uniform vec3 uTime;
uniform float daAlpha;
uniform float flash;
uniform vec4 flashColor;
uniform bool awesomeOutline;
uniform bool hidden;

const float offset = 1.0 / 128.0;
vec3 normalizeColor(vec3 color)
{
    return vec3(
        color[0] / 255.0,
        color[1] / 255.0,
        color[2] / 255.0
    );
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec4 colorMult(vec4 color){
    if (!hasTransform)
    {
        return color;
    }

    if (color.a == 0.0)
    {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }

    if (!hasColorTransform)
    {
        return color * openfl_Alphav;
    }

    color = vec4(color.rgb / color.a, color.a);

    mat4 colorMultiplier = mat4(0);
    colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
    colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
    colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
    colorMultiplier[3][3] = openfl_ColorMultiplierv.w;

    color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);

    if (color.a > 0.0)
    {
        return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
    }

    return vec4(0.0, 0.0, 0.0, 0.0);
}

void main(){
    vec2 uv = openfl_TextureCoordv.xy;
    
    // get snapped position
    if(!hidden){
        float psize = 0.04 * binaryIntensity;
        float psq = 1.0 / psize;

        float px = floor(uv.x * psq + 0.5) * psize;
        float py = floor(uv.y * psq + 0.5) * psize;
        
        vec4 colSnap = texture2D(bitmap, vec2(px, py));
        
        float lum = pow(1.0 - (colSnap.r + colSnap.g + colSnap.b) / 3.0, binaryIntensity);
        
        float qsize = psize * lum;
        float qsq = 1.0 / qsize;

        float qx = floor(uv.x * qsq + 0.5) * qsize;
        float qy = floor(uv.y * qsq + 0.5) * qsize;

        float rx = (px - qx) * lum + uv.x;
        float ry = (py - qy) * lum + uv.y;
        uv = vec2(rx, ry);
    }

    vec4 color = texture2D(bitmap, uv);

    vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);

    // [0] is the hue???
    swagColor[0] = swagColor[0] + uTime[0];
    swagColor[1] = swagColor[1] + uTime[1];
    swagColor[2] = swagColor[2] * (1.0 + uTime[2]);
    
    if(swagColor[1] < 0.0)
    {
        swagColor[1] = 0.0;
    }
    else if(swagColor[1] > 1.0)
    {
        swagColor[1] = 1.0;
    }

    color = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);

    if(flash != 0.0)
        color = mix(color,flashColor,flash) * color.a;
    
    color *= daAlpha;

    gl_FragColor = colorMult(color);
}
#pragma header
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

uniform int pixelSize;

void mainImage()
{
	vec2 uv = openfl_TextureCoordv.xy;
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
	vec2 iResolution = openfl_TextureSize;

    fragColor = vec4(0);    
    vec2 d = 1.0 / iResolution.xy;
    vec2 uvSla = (d.xy * float(pixelSize)) * floor(fragCoord.xy / float(pixelSize));
    
	for (int i = 0; i < pixelSize; i++)
		for (int j = 0; j < pixelSize; j++)
			fragColor += texture(iChannel0, uvSla.xy + vec2(d.x * float(i), d.y * float(j)));

	fragColor /= pow(float(pixelSize), 2.0);   
}
#pragma header
uniform float chromaticIntensity;
uniform float distortionIntensity;
uniform float zoom;
uniform float angle;
uniform vec2 offset;
uniform bool mirrorX;
uniform bool mirrorY;


vec2 computeUV( vec2 uv, float k, float kcube ){
    
    vec2 t = uv;
    float r2 = t.x * t.x + t.y * t.y;
	float f = 0.;
    
    if( kcube == 0.0){
        f = 1. + r2 * k;
    }else{
        f = 1. + r2 * ( k + kcube * sqrt( r2 ) );
    }
    
    vec2 nUv = f * t;


    float rads = radians(angle);
    mat2 rotationMatrix = mat2(
        cos(rads), -sin(rads),
        sin(rads), cos(rads) );

    mat2 fixRotation = mat2(  // the aspect ratio get squished bercause of the above code ^, this just unsquishes it
        0.5625, 0.0,
        0.0, 1.0
    );


    nUv /= zoom;
    
    nUv *= rotationMatrix;
    nUv *= fixRotation;
    nUv += 0.5;
    nUv += offset * vec2(0.00078125, 0.00138888);

    
    if(mirrorX){
        if ((nUv.x > 1.0 || nUv.x < 0.0) && abs(mod(nUv.x, 2.0)) > 1.0)
            nUv.x = (0.0-nUv.x)+1.0;
    }
    if(mirrorY){
        if ((nUv.y > 1.0 || nUv.y < 0.0) && abs(mod(nUv.y, 2.0)) > 1.0)
            nUv.y = (0.0-nUv.y)+1.0;
    }
    



    return vec2(abs(mod(nUv.x, 1.0)), abs(mod(nUv.y, 1.0)));
    
}

void main() {
    
    vec2 fragCoord = openfl_TextureCoordv.xy * openfl_TextureSize.xy;
    vec2 uv = ( fragCoord - .5*openfl_TextureSize.xy ) / openfl_TextureSize.y;

    float k = distortionIntensity * 0.9;
    float kcube = distortionIntensity * 0.5;
    
    float offset = chromaticIntensity * 0.1;


    vec2 rUV = computeUV( uv, k + offset, kcube );
    vec2 gUV = computeUV( uv, k, kcube );
    vec2 bUV = computeUV( uv, k - offset, kcube );
    vec4 red = texture2D( bitmap, rUV ); 
    vec4 green = texture2D( bitmap, gUV ); 
    vec4 blue = texture2D( bitmap, bUV ); 

    
    gl_FragColor = vec4( red.r, green.g, blue.b, green.a );

}

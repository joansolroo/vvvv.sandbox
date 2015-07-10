Texture2D tex0: PREVIOUS;
SamplerState s0 <string uiname="Sampler";> {Filter=MIN_MAG_MIP_LINEAR;AddressU=CLAMP;AddressV=CLAMP;};
float2 R:TARGETSIZE;
float2 resolution;

cbuffer controls:register(b0){
	float4x4 tTex;
};

float4 psTRANSFORM(float4 PosWVP:SV_POSITION,float2 x:TEXCOORD0):SV_TARGET{
	float4 c=tex0.SampleLevel(s0,x,0);
	c.xy = 1-c.xy;
    return c;
}


technique10 TransformTexture{
	pass P1
	{SetPixelShader(CompileShader(ps_4_0,psTRANSFORM()));}
}


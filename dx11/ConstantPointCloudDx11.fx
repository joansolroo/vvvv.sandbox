//@author: vux
//@help: template for standard shaders
//@tags: template
//@credits: 

Texture2D texture2d <string uiname="Texture";>;
Texture2D Depth <string uiname="Depth";>;
SamplerState linearSampler : IMMUTABLE
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};
 
cbuffer cbPerDraw : register( b0 )
{
	float4x4 tVP : VIEWPROJECTION;	
};

cbuffer cbPerObj : register( b1 )
{
	float4x4 tW : WORLD;
	float4 cAmb <bool color=true;String uiname="Color";> = { 1.0f,1.0f,1.0f,1.0f };
};

struct VS_IN
{
	float4 PosO : POSITION;
	float4 Normal : NORMAL;
	float4 TexCd : TEXCOORD0;

};

struct vs2ps
{
    float4 PosWVP: SV_POSITION;
    float4 TexCd: TEXCOORD0;
};

vs2ps VS(VS_IN input)
{
   
//inititalize all fields of output struct with 0
    vs2ps Out = (vs2ps)0;

	float DepthScale = 1;
	float4 originalPos = input.PosO;
	// change Position with Depth Map
	float4 depth = texture2d.SampleLevel(linearSampler,input.TexCd.xy,1);
	float4 Pos = float4(0,0,0,0);
	Pos += float4(input.TexCd.x - 0.5, 0.5-input.TexCd.y, 0, 0);
	Pos += float4(input.Normal.xyz * depth.r * -DepthScale,0);
	
    //transform position
    //Out.Pos = mul(mul(Pos, tW), tV);
	//Out.Pos.xy += mul(originalPos-1, tPos).xy;
	//Out.Pos = mul(Out.Pos, tP);
	
    //transform texturecoordinates
    //Out.TexCd = mul(TexCd, tTex);

	// oldcode
	
	vs2ps output;
	
    output.PosWVP  = mul(Pos,mul(tW,tVP));
    output.TexCd = input.TexCd;
    return output;
}




float4 PS(vs2ps In): SV_Target
{
    float4 col = texture2d.Sample(linearSampler,In.TexCd.xy) * cAmb;
    return col;
}





technique10 Constant
{
	pass P0
	{
		SetVertexShader( CompileShader( vs_4_0, VS() ) );
		SetPixelShader( CompileShader( ps_4_0, PS() ) );
	}
}





//@author: vux
//@help: template for standard shaders
//@tags: template
//@credits: 

Texture2D texture2d <string uiname="Texture";>;

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
	float4 TexCd : TEXCOORD0;

};

struct vs2ps
{
    float4 PosWVP: SV_POSITION;
    float4 TexCd: TEXCOORD0;
};

vs2ps VS(VS_IN input)
{
    vs2ps output;
	float4 col = texture2d.SampleLevel(linearSampler,input.TexCd.xy,1);
    //if(col.z > 0.8 && col.z < 6)
		output.PosWVP  = mul(col,mul(tW,tVP));
	//else
	//	output.PosWVP  = mul(float4(0,0,6,1),mul(tW,tVP));
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





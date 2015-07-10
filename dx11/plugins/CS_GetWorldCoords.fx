
//This is the buffer from the renderer
//Renderer automatically assigns BACKBUFFER semantic
RWStructuredBuffer<float3> rwbuffer : BACKBUFFER;

//Texture we want to read from
Texture2D texXYZ <string uiname="Texture World";>;

//Buffer containing uvs for sampling
StructuredBuffer<float2> uv <string uiname="UV Buffer";>;

SamplerState sPoint : IMMUTABLE
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Border;
    AddressV = Border;
};


[numthreads(64, 1, 1)]
void CS( uint3 i : SV_DispatchThreadID)
{ 
	float3 xyz = texXYZ.SampleLevel(sPoint,uv[i.x],0).rgb;
	
	rwbuffer[i.x] = xyz;

}

technique11 Process
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, CS() ) );
	}
}








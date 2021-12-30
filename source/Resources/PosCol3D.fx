float4x4 gWorldViewProj : WorldViewProjection;
Texture2D gDiffuseMap : DiffuseMap;

SamplerState samplePoint
{
	Filter = MIN_MAG_MIP_POINT;
	AddressU = Border; // or mirror or clamp or border
	AddressV = Clamp; // or mirror or clamp or border
	BorderColor = float4(0.0f, 0.0f, 1.0f, 1.0f);
};

struct VS_INPUT
{
	float3 Position : POSITION;
	float2 TextureUV : TEXCOORD;
	float3 Color : COLOR;
};

struct VS_OUTPUT
{
	float4 Position : SV_POSITION;
	float2 TextureUV : TEXCOORD;
	float3 Color : COLOR;
};

// Vertex Shader
VS_OUTPUT VS(VS_INPUT input)
{
	VS_OUTPUT output = (VS_OUTPUT)0;
	output.Position = mul(float4(input.Position, 1.f), gWorldViewProj);
	output.TextureUV = input.TextureUV;
	output.Color = input.Color;
	return output;
};

// Pixel Shader
float4 PS(VS_OUTPUT input) : SV_TARGET
{
	return float4(gDiffuseMap.Sample(samplePoint, input.TextureUV) * input.Color, 1.f);
};

// Technique
technique11 DefaultTechnique
{
	pass P0
	{
		SetVertexShader(CompileShader(vs_5_0, VS()));
		SetGeometryShader(NULL);
		SetPixelShader(CompileShader(ps_5_0, PS()));
	}
};
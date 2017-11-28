Shader "XRay/Absorption"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		Sigma("Sigma",float) = 30.0
		size("Size",Vector) = (1.0,1.0,0.0,0.0)
	}
	SubShader
	{
		//Tags{ "RenderType" = "Opaque" }
		//LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;  //深度图,由Depth Shader传过来。
			uniform float3 DiffuseMaterial;  //不清楚这个是怎么传的
			uniform float4 size;	//也不知道是什么意思
			uniform float Sigma;	//是参数，系数，可以不用管是多少。

			float4 vert(float4 vPosition:POSITION) :SV_POSITION
			{
				////float4 vPos = vPosition;
				//float4 vPos = ComputeScreenPos(vPosition);
				//return vPos;


				return vPosition;

			}

			float4 frag(float4 fragCoord:WPOS) : SV_Target
			{
				float2 texCoord = fragCoord.xy / size.xy;
				//float thickness = abs(texture2D(_MainTex, texCoord).r);
				float thickness = abs(tex2D(_MainTex, texCoord).r);

				float fresnel = 1.0 - tex2D(_MainTex, texCoord).g;
				float intensity = fresnel * exp(-Sigma * thickness);
				return float4(intensity * DiffuseMaterial,1);
			}
			ENDCG
		}
	}
}
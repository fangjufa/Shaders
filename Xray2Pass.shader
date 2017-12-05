Shader "Xray/Xray2Pass"
{
	SubShader
	{

		Pass
		{
			Blend one one
			Cull Off
			ZWrite Off			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 vNormal :NORMAL;
				float4 fragCoord:TEXCOORD1;
				float3 vPosition:TEXCOORD0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.fragCoord = ComputeScreenPos(o.vertex);
				o.vPosition = mul(UNITY_MATRIX_MV, v.vertex).xyz;
				o.vNormal = mul(UNITY_MATRIX_IT_MV, v.normal);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 N = normalize(i.vNormal);
				float3 I = normalize(i.vPosition);


				float cosTheta = abs(dot(I, N));
				float fresnel = pow(1.0 - cosTheta, 4.0);

				float depth = i.fragCoord.z;

				return float4(depth, fresnel, 0, 0);

				//return col;
			}
			ENDCG
		}

		Pass
		{
			Blend one one
			Cull Back
			ZWrite Off
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 vNormal :NORMAL;
				float4 fragCoord:TEXCOORD1;
				float3 vPosition:TEXCOORD0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.fragCoord = ComputeScreenPos(o.vertex);
				o.vPosition = mul(UNITY_MATRIX_MV, v.vertex).xyz;
				o.vNormal = mul(UNITY_MATRIX_IT_MV, v.normal);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 N = normalize(i.vNormal);
				float3 I = normalize(i.vPosition);

				float cosTheta = abs(dot(I, N));
				float fresnel = pow(1.0 - cosTheta, 4.0);

				//float depth = depthScale * gl_FragCoord.z;
				float depth =  -1 * i.fragCoord.z;

				//gl_FragColor = float4(depth, fresnel, 0, 0);
				return float4(depth, fresnel, 0, 0);

				//return col;
			}
			ENDCG
		}
	}
}

Shader "XRay/XRayDepth"
{
	Properties
	{
		depthScale("DepthScale",float) = -1  //or -1
	}
	SubShader
	{
		//Tags { "RenderType" = "Opaque" }
		//LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform float depthScale;

			struct v2f
			{
				float4 vertex : SV_POSITION; //gl_Position
				float3 vNormal :NORMAL;      //vNormal
				float4 fragCoord:TEXCOORD1;  
				float3 vPosition:TEXCOORD0;  //vPosition
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.fragCoord = ComputeScreenPos(o.vertex);  //像素的屏幕坐标。
				o.vPosition = mul(UNITY_MATRIX_MV, v.vertex).xyz;
				o.vNormal = mul(UNITY_MATRIX_IT_MV, v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 N = normalize(i.vNormal);
				float3 I = normalize(i.vPosition); //view direction


				float cosTheta = abs(dot(I, N));
				float fresnel = pow(1.0 - cosTheta, 4.0);

				//float depth = depthScale * gl_FragCoord.z;
				float depth = depthScale * i.fragCoord.z;
				//float depth = depthScale * gl_FragCoord.z;

				 //gl_FragColor = float4(depth, fresnel, 0, 0);
				return float4(depth, fresnel, 0, 0);

				//return col;
			}
			ENDCG
		}
	}
}

//varying vec3 vNormal;
//varying vec3 vPosition;
//
//uniform mat4 Projection;
//uniform mat4 Modelview;
//uniform mat3 NormalMatrix;
//
//void main()
//{
//	vPosition = (Modelview * Position).xyz;
//	vNormal = NormalMatrix * Normal;
//	gl_Position = Projection * Modelview * Position;
//}


//uniform float DepthScale;
//varying vec3 vNormal;
//varying vec3 vPosition;
//
//void main()
//{
//	vec3 N = normalize(vNormal);
//	vec3 P = vPosition;
//	vec3 I = normalize(P);
//	float cosTheta = abs(dot(I, N));
//	float fresnel = pow(1.0 - cosTheta, 4.0);
//
//	float depth = DepthScale * gl_FragCoord.z;
//
//	gl_FragColor = vec4(depth, fresnel, 0, 0);
//}
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DistanceOutline"
{
	//Properties
	//{
	//	_Color("Color", Color) = (1.0,1.0,1.0,1.0)//This is for the fallback
	//}
	SubShader{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		//Blend SrcAlpha OneMinusSrcAlpha
		Blend One One
		ZWrite Off
		Cull Off

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _CameraDepthTexture; //Depth Texture,unity will assign this value.uniform would be optional.
			//uniform sampler2D _LastCameraDepthTexture;

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 projPos : TEXCOORD1; //Screen position of pos
				//float3 viewVec : SV_POSITION;
				//float3 normal;
			};

			vertexOutput vert(appdata_base v) {
				vertexOutput o;
//#if UNITY_5_6
//				o.pos = UnityObjectToClipPos(v.vertex);//it is only used in unity 5.6 or higher version.
//#else
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);//UnityObjectToClipPos(v.vertex);
//#endif
				o.projPos = ComputeScreenPos(o.pos);
				//o.normal = v.normal;
				return o;
			}

			half4 frag(vertexOutput i) : COLOR{
				//Get the distance to the camera from the depth buffer for this point
				float sceneZ = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)).r);//这个重叠部分，对于多个物体有用，但是对于只有一个物体，遮挡之后估计就看不到背面的了。
				//Actual distance to the camera        I know it's 100
				float partZ = i.projPos.z;
				//float partZ = 100;

				sceneZ = (1 - sceneZ / 1000);
				sceneZ = sceneZ * 10 - 8.7;

				fixed4 finalColor = float4(0, 1 , 1 , sceneZ);
				return finalColor;
			}
			ENDCG
		}
	}
	FallBack "Transparent"
}
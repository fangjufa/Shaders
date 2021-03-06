﻿Shader "Stencil/Back" {
	SubShader{
		Pass{
			Stencil{
				Ref 2        //参考值为2，stencilBuffer值默认为0  
				Comp equal            //stencil比较方式是永远通过 
				//Pass replace
			}
			CGPROGRAM
			#pragma vertex vert  
			#pragma fragment frag  
			struct appdata {
				float4 vertex : POSITION;
			};
			struct v2f {
				float4 pos : SV_POSITION;
			};
			v2f vert(appdata v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;
			}
			half4 frag(v2f i) : SV_Target{
				return half4(1,0,0,1);
			}
			ENDCG
		}
	}
}
Shader "Stencil/Mask" {
	SubShader{
		Pass{
			ColorMask 0  //为了不写入任何颜色。
			ZWrite off   //这句话也很重要，如果不把这句话写上，就没有效果。
			Stencil{
				Ref 2        //参考值为2，通过将Comp的参数改为less或greater,测得stencilBuffer值默认为0  
				Comp always            //stencil比较方式是永远通过  
				Pass replace           //pass的处理是替换，就是拿2替换buffer 的值 ，即在Comp的比较条件通过的情况下执行的方法。
									   //这个例子中，Comp是always，所以stencilbuffer的值在该物体区域会一直被替换成2.
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
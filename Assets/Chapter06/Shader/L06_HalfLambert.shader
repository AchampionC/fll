// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FengLL/Chapter06/L06_HalfLambert"
{
    Properties
    {
        _Diffuse("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
  
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            fixed4 _Diffuse;
            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 nDirWS : TEXCOORD0;
            };

            v2f vert(a2v v) 
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.nDirWS = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET // 告诉渲染器, 把用户的颜色存储到Render Target上, 这里将输出到默认的帧缓存中
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                float3 nDirWS = normalize(i.nDirWS);
                float3 lDirWS = normalize(_WorldSpaceLightPos0);

                float ndotl = dot(nDirWS, lDirWS);
                fixed halfLambert = 0.5 * ndotl + 0.5;
                fixed3 finalRBG = ambient + _Diffuse.rgb * halfLambert * _LightColor0.rgb;

                return fixed4(finalRBG, 1.0);
            }
            ENDCG
        }
    }
}

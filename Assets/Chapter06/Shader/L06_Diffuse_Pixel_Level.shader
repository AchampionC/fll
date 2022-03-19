// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FengLL/Chapter06/L06_Diffuse_Pixel_Level"
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
                float3 posWS : TEXCOORD0;
                float3 nDirWS : TEXCOORD1;
                fixed3 color : COLOR0;
            };

            v2f vert(a2v v) 
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.posWS = UnityObjectToWorldDir(v.vertex);
                o.nDirWS = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET // 告诉渲染器, 把用户的颜色存储到Render Target上, 这里将输出到默认的帧缓存中
            {
                float3 ndirWS = normalize(i.nDirWS);
                float3 lDir = normalize(_WorldSpaceLightPos0);
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT;
                float lambert = max(0, dot(ndirWS, lDir));
                float3 finalRBG = ambient + _Diffuse.rgb * lambert * _LightColor0.rgb;

                return fixed4(finalRBG, 1.0);
            }
            ENDCG
        }
    }
}

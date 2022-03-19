// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FengLL/Chapter06/L06_BlinnPhong"
{
    Properties
    {
        _DiffuseCol ("DiffuseCol", Color) = (1.0, 1.0, 1.0, 1.0)
        _SpecularCol("SpecularCol", Color) = (1.0, 1.0, 1.0, 1.0)
        _SpecularPow("Gloss", Range(8, 256)) = 20
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
            float _SpecularPow;
            fixed4 _DiffuseCol;
            fixed4 _SpecularCol;
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
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT;
                float3 nDirWS = normalize(i.nDirWS);
                float3 lDirWS = normalize(_WorldSpaceLightPos0);
                float3 vDirWS = normalize(_WorldSpaceCameraPos - i.posWS);
                float3 hDir = normalize(lDirWS + vDirWS);

                float3 rlDirWS = normalize(reflect(-lDirWS, nDirWS));
                float3 ndotl = max(0, dot(nDirWS, lDirWS));
                float3 lambert = _DiffuseCol * ndotl;
                float blinnphong = pow(max(0, dot(nDirWS, hDir)), _SpecularPow);
                fixed3 finalRGB = ambient + _LightColor0.rgb * blinnphong * _SpecularCol + lambert;
                return fixed4(finalRGB, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}

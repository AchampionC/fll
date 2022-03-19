// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FengLL/Chapter06/L06_Specular_Vertex_Level"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
        _Specular("Specular", Color) = (1.0, 1.0, 1.0, 1.0)
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
            fixed4 _Diffuse;
            fixed4 _Specular;
            float _SpecularPow;
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
                
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT;
                float3 lDir = normalize(_WorldSpaceLightPos0);
                float3 vDir = normalize(_WorldSpaceCameraPos - o.posWS);
                float3 nDirWS = normalize(o.nDirWS);
                float3 rlDir = normalize(reflect(-lDir, nDirWS));
                
                float lambert = max(0, dot(o.nDirWS, lDir));
                float spe = pow(max(0, dot(rlDir, vDir)), _SpecularPow);

                o.color = ambient +  _LightColor0.rgb * _Diffuse * lambert + _LightColor0.rgb * _Specular * spe;


                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET // 告诉渲染器, 把用户的颜色存储到Render Target上, 这里将输出到默认的帧缓存中
            {
                return fixed4(i.color, 1.0);
            }
            ENDCG
        }
    }
}

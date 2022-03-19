Shader "FengLL/Chapter06/L06_Vertex_Level"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }


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
                fixed3 color : COLOR;
            };


            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT;
                fixed3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                fixed3 worldLight  = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                o.color = ambient + diffuse;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // apply fog
                return fixed4(i.color, 1.0);
            }
            ENDCG
        }
    }
}

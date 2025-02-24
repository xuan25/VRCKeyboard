Shader "Xuan25/ChromaKeyShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        [Toggle] _DepthOverride ("Enable Depth Override", Float) = 0
        _DepthOverrideValue ("Depth Override Value", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            // #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color;
            float _DepthOverride;
            float _DepthOverrideValue;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // depth override
                // force depth to 1 to always render on top
                if (_DepthOverride > 0.5)
                {
                    o.vertex.z = _DepthOverrideValue;
                }

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;
                return col;
            }
            ENDCG
        }
    }
}

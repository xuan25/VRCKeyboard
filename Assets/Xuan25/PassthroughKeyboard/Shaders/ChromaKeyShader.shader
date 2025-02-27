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
        Tags { "RenderType"="Opaque" "Queue"="Background" } // We do not do any z-testing, so we render first
        LOD 100
        ZWrite On       // Enable ZWrite to write to depth buffer so anything rendered after this will be occluded (default for Opaque)
        ZClip False     // Disable ZClip so that the object is not clipped by the near plane
        ZTest Always    // Disable Early-ZTest to always render regardless of depth, which allows us to render on top of everything

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

            struct fout {
                half4 color : SV_Target;
                float depth : SV_Depth;
            };    

            fixed4 _Color;
            float _DepthOverride;
            float _DepthOverrideValue;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fout frag (v2f i)
            {
                fout o;

                o.color = _Color;

                // depth override
                // force depth to 1 to always render on top
                if (_DepthOverride > 0.5)
                {
                    o.depth = _DepthOverrideValue;
                } else {
                    o.depth = i.vertex.z;
                }
                
                return o;
            }
            ENDCG
        }
    }
}

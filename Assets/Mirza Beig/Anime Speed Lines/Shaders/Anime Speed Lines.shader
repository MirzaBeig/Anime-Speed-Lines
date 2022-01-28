// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mirza/Speed Lines"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Colour("Colour", Color) = (1,1,1,1)
		_SpeedLinesTiling("Speed Lines Tiling", Float) = 200
		_SpeedLinesRadialScale("Speed Lines Radial Scale", Range( 0 , 10)) = 0.1
		_SpeedLinesPower("Speed Lines Power", Float) = 1
		_SpeedLinesRemap("Speed Lines Remap", Range( 0 , 1)) = 0.8
		_SpeedLinesAnimation("Speed Lines Animation", Float) = 3
		_MaskScale("Mask Scale", Range( 0 , 2)) = 1
		_MaskHardness("Mask Hardness", Range( 0 , 1)) = 0
		_MaskPower("Mask Power", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _SpeedLinesRadialScale;
			uniform float _SpeedLinesTiling;
			uniform float _SpeedLinesAnimation;
			uniform float _SpeedLinesPower;
			uniform float _SpeedLinesRemap;
			uniform float _MaskScale;
			uniform float _MaskHardness;
			uniform float _MaskPower;
			uniform float4 _Colour;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 SceneColour7 = tex2D( _MainTex, uv_MainTex );
				float2 CenteredUV15_g1 = ( i.uv.xy - float2( 0.5,0.5 ) );
				float2 break17_g1 = CenteredUV15_g1;
				float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * _SpeedLinesRadialScale * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * _SpeedLinesTiling )));
				float2 appendResult58 = (float2(( -_SpeedLinesAnimation * _Time.y ) , 0.0));
				float simplePerlin2D10 = snoise( ( appendResult23_g1 + appendResult58 ) );
				simplePerlin2D10 = simplePerlin2D10*0.5 + 0.5;
				float temp_output_1_0_g4 = _SpeedLinesRemap;
				float SpeedLines21 = saturate( ( ( pow( simplePerlin2D10 , _SpeedLinesPower ) - temp_output_1_0_g4 ) / ( 1.0 - temp_output_1_0_g4 ) ) );
				float2 texCoord6_g2 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float Gradient15_g2 = ( 1.0 - length( (texCoord6_g2*2.0 + -1.0) ) );
				float temp_output_17_0_g2 = ( 1.0 - _MaskScale );
				float temp_output_1_0_g3 = temp_output_17_0_g2;
				float lerpResult20_g2 = lerp( temp_output_17_0_g2 , 1.0 , ( 1.0 - _MaskHardness ));
				float Mask24 = pow( ( 1.0 - saturate( ( ( Gradient15_g2 - temp_output_1_0_g3 ) / ( lerpResult20_g2 - temp_output_1_0_g3 ) ) ) ) , _MaskPower );
				float MaskedSpeedLines29 = ( SpeedLines21 * Mask24 );
				float3 ColourRGB38 = (_Colour).rgb;
				float ColourA40 = _Colour.a;
				float4 lerpResult2 = lerp( SceneColour7 , float4( ( MaskedSpeedLines29 * ColourRGB38 ) , 0.0 ) , ( MaskedSpeedLines29 * ColourA40 ));
				

				finalColor = lerpResult2;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18921
0;72.66667;1280;522;3470.126;28.54175;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;55;-3801.88,-316.5227;Inherit;False;Property;_SpeedLinesAnimation;Speed Lines Animation;5;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;57;-3620.437,-217.8602;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;59;-3556.806,-310.7944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-3382.927,-307.826;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-3741.493,-463.1422;Inherit;False;Property;_SpeedLinesTiling;Speed Lines Tiling;1;0;Create;True;0;0;0;False;0;False;200;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3767.248,-555.6451;Inherit;False;Property;_SpeedLinesRadialScale;Speed Lines Radial Scale;2;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;11;-3423.667,-571.0438;Inherit;True;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0.38;False;4;FLOAT;28.02;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-3212.592,-310.2251;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-2997.342,-545.3854;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2969.352,46.44592;Inherit;False;Property;_MaskScale;Mask Scale;6;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2683.448,-295.9243;Inherit;False;Property;_SpeedLinesPower;Speed Lines Power;3;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2968.513,143.3944;Inherit;False;Property;_MaskHardness;Mask Hardness;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;10;-2682.032,-544.4982;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2349.465,-576.2127;Inherit;False;Property;_SpeedLinesRemap;Speed Lines Remap;4;0;Create;True;0;0;0;False;0;False;0.8;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;13;-2622.113,42.05579;Inherit;True;Radial Mask;-1;;2;5ad56e17650ce9b4db75d2f55c6ae7cf;0;3;13;FLOAT2;0,0;False;19;FLOAT;1;False;18;FLOAT;0.94;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;48;-2308.395,-464.9206;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;5.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-2274.064,37.82519;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2265.914,271.0869;Inherit;False;Property;_MaskPower;Mask Power;8;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;50;-1987.354,-541.1801;Inherit;True;Inverse Lerp;-1;;4;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;-1659.837,-483.6926;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;16;-2005.64,38.10326;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3.91;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1481.31,-489.1878;Inherit;False;SpeedLines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1757.859,33.23505;Inherit;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2627.142,563.1894;Inherit;False;21;SpeedLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2624.943,647.835;Inherit;False;24;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-2736.949,911.6467;Inherit;False;Property;_Colour;Colour;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;3;-2744.521,-919.8046;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2307.729,573.4354;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;-2491.353,914.8679;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-2282.18,918.6451;Inherit;False;ColourRGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;6;-2553.676,-922.6004;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-2299.421,1009.243;Inherit;False;ColourA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-2054.516,569.8716;Inherit;False;MaskedSpeedLines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-934.8308,-32.66438;Inherit;False;38;ColourRGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-2189.996,-922.8203;Inherit;False;SceneColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-998.1222,224.127;Inherit;False;40;ColourA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1006.442,102.6258;Inherit;False;29;MaskedSpeedLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-959.5545,-111.3993;Inherit;False;29;MaskedSpeedLines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-672.9068,159.2483;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-680.7075,-93.04643;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;-692.7988,-218.4032;Inherit;False;7;SceneColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2;-358.2381,-165.4041;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-33.73761,-104.2799;Float;False;True;-1;2;ASEMaterialInspector;0;2;Mirza/Speed Lines;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;59;0;55;0
WireConnection;56;0;59;0
WireConnection;56;1;57;0
WireConnection;11;3;22;0
WireConnection;11;4;23;0
WireConnection;58;0;56;0
WireConnection;54;0;11;0
WireConnection;54;1;58;0
WireConnection;10;0;54;0
WireConnection;13;19;17;0
WireConnection;13;18;18;0
WireConnection;48;0;10;0
WireConnection;48;1;51;0
WireConnection;14;0;13;0
WireConnection;50;1;53;0
WireConnection;50;3;48;0
WireConnection;52;0;50;0
WireConnection;16;0;14;0
WireConnection;16;1;25;0
WireConnection;21;0;52;0
WireConnection;24;0;16;0
WireConnection;15;0;26;0
WireConnection;15;1;27;0
WireConnection;43;0;33;0
WireConnection;38;0;43;0
WireConnection;6;0;3;0
WireConnection;40;0;33;4
WireConnection;29;0;15;0
WireConnection;7;0;6;0
WireConnection;37;0;30;0
WireConnection;37;1;44;0
WireConnection;45;0;36;0
WireConnection;45;1;46;0
WireConnection;2;0;8;0
WireConnection;2;1;45;0
WireConnection;2;2;37;0
WireConnection;0;0;2;0
ASEEND*/
//CHKSM=6B3A4225231B9277D1728004EB901E313305AEDE
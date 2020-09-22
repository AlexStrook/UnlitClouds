// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "_Clouds/Clouds Unlit Vertex Color"
{
	Properties
	{
		_TopTexture0("Top Texture 0", 2D) = "white" {}
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 21.6
		_TessMin( "Tess Min Distance", Float ) = 0.7
		_TessMax( "Tess Max Distance", Float ) = 10.94
		_NoiseScaleA("NoiseScale A", Vector) = (1,1,1,0)
		_3dNoiseSizeA("3dNoise Size A", Float) = 0
		_SpeedA("Speed A", Float) = 0
		_DirectionA("Direction A", Vector) = (1,0,0,0)
		_NoiseStrengthA("Noise Strength A", Range( 0 , 1)) = 0
		_3dNoiseSizeB("3dNoise Size B", Float) = 0
		_NoiseScaleB("NoiseScale B", Vector) = (1,1,1,0)
		_SpeedB("Speed B", Float) = 0
		_DirectionB("Direction B", Vector) = (1,0,0,0)
		_NoiseStrengthB("Noise Strength B", Range( 0 , 1)) = 0
		_NoiseScaleC("NoiseScale C", Vector) = (1,1,1,0)
		_3dNoiseSizeC("3dNoise Size C", Float) = 0
		_SpeedC("SpeedC", Float) = 0
		_DirectionC("DirectionC", Vector) = (1,0,0,0)
		_NoiseStrengthC("Noise Strength C", Range( 0 , 1)) = 0
		_textureDetail("textureDetail", Range( 0 , 1)) = 0
		_TextureColor("Texture Color", Color) = (0,0,0,0)
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_Fallof("Fallof", Float) = 0
		_VertexColorMult("Vertex Color Mult", Float) = 1
		_RimColor("Rim Color", Color) = (0,0,0,0)
		_FresnelBSP("FresnelBSP", Vector) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#define ASE_TEXTURE_PARAMS(textureName) textureName

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _NoiseStrengthA;
		uniform float3 _DirectionA;
		uniform float _SpeedA;
		uniform float _3dNoiseSizeA;
		uniform float3 _NoiseScaleA;
		uniform float3 _DirectionB;
		uniform float _SpeedB;
		uniform float _3dNoiseSizeB;
		uniform float3 _NoiseScaleB;
		uniform float _NoiseStrengthB;
		uniform float3 _DirectionC;
		uniform float _SpeedC;
		uniform float _3dNoiseSizeC;
		uniform float3 _NoiseScaleC;
		uniform float _NoiseStrengthC;
		uniform float _VertexColorMult;
		uniform float4 _TextureColor;
		uniform sampler2D _TopTexture0;
		uniform float2 _Tiling;
		uniform float _Fallof;
		uniform float _textureDetail;
		uniform float3 _FresnelBSP;
		uniform float4 _RimColor;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 objToWorldDir239 = mul( unity_ObjectToWorld, float4( float3(0,1,0), 0 ) ).xyz;
			float mulTime15 = _Time.y * _SpeedA;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float simplePerlin3D3 = snoise( ( ( _DirectionA * mulTime15 ) + ( _3dNoiseSizeA * ( ase_worldPos * _NoiseScaleA ) ) ) );
			float temp_output_8_0 = (0.0 + (simplePerlin3D3 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float3 objToWorldDir213 = mul( unity_ObjectToWorld, float4( float3(0,1,0), 0 ) ).xyz;
			float mulTime75 = _Time.y * _SpeedB;
			float simplePerlin3D78 = snoise( ( ( _DirectionB * mulTime75 ) + ( _3dNoiseSizeB * ( ase_worldPos * _NoiseScaleB ) ) ) );
			float3 objToWorldDir257 = mul( unity_ObjectToWorld, float4( float3(0,1,0), 0 ) ).xyz;
			float mulTime248 = _Time.y * _SpeedC;
			float3 temp_output_252_0 = ( ( _DirectionC * mulTime248 ) + ( _3dNoiseSizeC * ( ase_worldPos * _NoiseScaleC ) ) );
			float simplePerlin3D255 = snoise( temp_output_252_0 );
			v.vertex.xyz += ( ( objToWorldDir239 * _NoiseStrengthA * temp_output_8_0 ) + ( objToWorldDir213 * (0.0 + (simplePerlin3D78 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) * _NoiseStrengthB ) + ( objToWorldDir257 * (0.0 + (simplePerlin3D255 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) * _NoiseStrengthC ) );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float mulTime248 = _Time.y * _SpeedC;
			float3 temp_output_252_0 = ( ( _DirectionC * mulTime248 ) + ( _3dNoiseSizeC * ( ase_worldPos * _NoiseScaleC ) ) );
			float3 NoiseWorldPos364 = temp_output_252_0;
			float4 triplanar194 = TriplanarSamplingSF( _TopTexture0, NoiseWorldPos364, ase_worldNormal, _Fallof, _Tiling, 1.0, 0 );
			float mulTime15 = _Time.y * _SpeedA;
			float simplePerlin3D3 = snoise( ( ( _DirectionA * mulTime15 ) + ( _3dNoiseSizeA * ( ase_worldPos * _NoiseScaleA ) ) ) );
			float temp_output_8_0 = (0.0 + (simplePerlin3D3 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float NoiseA366 = temp_output_8_0;
			float2 appendResult376 = (float2(ase_worldPos.x , ase_worldPos.z));
			float simplePerlin2D374 = snoise( ( appendResult376 * 0.1 ) );
			float4 lerpResult210 = lerp( saturate( ( pow( i.vertexColor , 0.454545 ) * _VertexColorMult ) ) , _TextureColor , ( ( ( 1.0 - triplanar194.x ) * _textureDetail ) * saturate( NoiseA366 ) * (0.25 + (simplePerlin2D374 - -1.0) * (1.0 - 0.25) / (1.0 - -1.0)) ));
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV346 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode346 = ( _FresnelBSP.x + _FresnelBSP.y * pow( 1.0 - fresnelNdotV346, _FresnelBSP.z ) );
			o.Emission = saturate( ( lerpResult210 + ( fresnelNode346 * _RimColor ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16900
-32;253;984;726;-4033.508;-119.6236;1.5407;True;False
Node;AmplifyShaderEditor.CommentaryNode;242;4334.598,3400.093;Float;False;1681.438;904.9535;noise B;17;259;258;257;256;255;254;252;251;250;249;248;246;245;244;243;279;364;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;363;4392.098,1354.656;Float;False;1575.466;961.8254;Noise A;17;6;136;16;15;86;5;135;85;7;238;239;14;3;8;123;125;366;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;6;4444.608,1946.557;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;4442.098,1598.43;Float;False;Property;_SpeedA;Speed A;8;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;136;4460.632,2132.481;Float;False;Property;_NoiseScaleA;NoiseScale A;6;0;Create;True;0;0;False;0;1,1,1;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;243;4408.489,3739.104;Float;False;Property;_SpeedC;SpeedC;18;0;Create;True;0;0;False;0;0;10.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;244;4384.599,3963.614;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;245;4401.574,4121.045;Float;False;Property;_NoiseScaleC;NoiseScale C;16;0;Create;True;0;0;False;0;1,1,1;1,1,2.02;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;86;4663.145,1404.656;Float;False;Property;_DirectionA;Direction A;9;0;Create;True;0;0;False;0;1,0,0;1.5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;4710.632,2040.481;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;5;4615.051,1817.031;Float;False;Property;_3dNoiseSizeA;3dNoise Size A;7;0;Create;True;0;0;False;0;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;4612.297,4070.366;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;248;4605.451,3742.736;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;279;4568.108,3554.552;Float;False;Property;_DirectionC;DirectionC;19;0;Create;True;0;0;False;0;1,0,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;15;4654.397,1604.73;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;4534.873,3854.899;Float;False;Property;_3dNoiseSizeC;3dNoise Size C;17;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;4770.647,3923.612;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;4784.732,3693.801;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;4905.949,1551.789;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;4872.709,1875.656;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;281;4115.208,-38.51873;Float;False;1811.842;1319.317;COLOR;23;210;204;318;371;369;240;320;370;193;241;211;319;192;194;365;198;197;378;379;374;375;377;376;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;5079.703,1854.33;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;252;4944.229,3832.367;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;214;4317.949,2412.926;Float;False;1681.438;904.9535;noise B;16;79;143;74;75;144;80;76;87;77;78;149;151;148;212;213;145;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;3;5268.188,1847.958;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;364;5080.631,4004.96;Float;False;NoiseWorldPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;375;4343.468,937.3293;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;79;4391.839,2751.937;Float;False;Property;_SpeedB;Speed B;13;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;365;4156.804,383.9981;Float;False;364;NoiseWorldPos;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;198;4168.964,640.3564;Float;False;Property;_Fallof;Fallof;24;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;376;4539.468,968.3293;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;8;5524.887,1844.041;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;74;4367.949,2976.447;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;143;4384.924,3133.879;Float;False;Property;_NoiseScaleB;NoiseScale B;12;0;Create;True;0;0;False;0;1,1,1;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;197;4170.305,475.2054;Float;False;Property;_Tiling;Tiling;23;0;Create;True;0;0;False;0;0,0;0.04,0.04;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;378;4482.468,1096.329;Float;False;Constant;_Float0;Float 0;25;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;4595.647,3083.199;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;75;4588.801,2755.57;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;366;5748.416,2067.205;Float;False;NoiseA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;194;4444.903,450.592;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;145;4561.48,2563.366;Float;False;Property;_DirectionB;Direction B;14;0;Create;True;0;0;False;0;1,0,0;1.48,-0.86,-0.36;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;192;4743.418,11.88875;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;377;4677.468,1027.329;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;80;4518.223,2867.733;Float;False;Property;_3dNoiseSizeB;3dNoise Size B;11;0;Create;True;0;0;False;0;0;1.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;4938.91,145.7891;Float;False;Property;_VertexColorMult;Vertex Color Mult;25;0;Create;True;0;0;False;0;1;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;374;4813.44,1007.488;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;4753.997,2936.445;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;4768.082,2706.634;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;319;4582.11,791.982;Float;False;366;NoiseA;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;211;4874.622,463.2088;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;241;4536.446,687.6609;Float;False;Property;_textureDetail;textureDetail;21;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;193;4962.068,25.63408;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.454545;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;5057.172,580.0022;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;320;4883.821,799.5373;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;356;6106.303,1660.543;Float;False;Property;_FresnelBSP;FresnelBSP;27;0;Create;True;0;0;False;0;0,0,0;0.41,1.55,3.65;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;5191.03,44.91639;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;4927.579,2845.2;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;379;5017.517,974.5007;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.25;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;5223.026,646.053;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;346;6372.781,1679.91;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;204;5104.326,283.5752;Float;False;Property;_TextureColor;Texture Color;22;0;Create;True;0;0;False;0;0,0,0,0;0.509434,0.4349413,0.5047782,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;238;5261.007,1515.841;Float;False;Constant;_Vector0;Vector 0;22;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;255;5232.708,3823.158;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;254;5246.329,3491.093;Float;False;Constant;_Vector5;Vector 5;22;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;350;6366.394,1440.562;Float;False;Property;_RimColor;Rim Color;26;0;Create;True;0;0;False;0;0,0,0,0;0.1415094,0.1415094,0.07542719,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;371;5362.035,55.19904;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;212;5229.679,2503.926;Float;False;Constant;_Vector2;Vector 2;22;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;78;5216.059,2835.991;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;239;5489.639,1516.662;Float;False;Object;World;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;125;5395.798,1727.332;Float;False;Property;_NoiseStrengthA;Noise Strength A;10;0;Create;True;0;0;False;0;0;0.472;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;258;5584.383,3849.455;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;257;5442.313,3493.872;Float;False;Object;World;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformDirectionNode;213;5426.699,2515.469;Float;False;Object;World;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;149;5567.733,2862.288;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;5392.92,2707.076;Float;False;Property;_NoiseStrengthB;Noise Strength B;15;0;Create;True;0;0;False;0;0;0.182;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;210;5583.373,301.7911;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;256;5409.569,3694.243;Float;False;Property;_NoiseStrengthC;Noise Strength C;20;0;Create;True;0;0;False;0;0;0.071;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;349;6658.039,1715.342;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;348;6953.387,1712.356;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;5830.387,2641.828;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;5847.036,3628.995;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;5850.154,1830.067;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;174;7780.481,2672.388;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;6311.289,2742.257;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;169;7176.476,2656.444;Float;False;Property;_blendfadedist;blend fade dist;28;0;Create;True;0;0;False;0;0;0.388;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;172;7490.476,2668.444;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;355;7268.551,1822.479;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;368;8249.455,2513.938;Float;False;True;6;Float;ASEMaterialInspector;0;0;Unlit;_Clouds/Clouds Unlit Vertex Color;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;21.6;0.7;10.94;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;135;0;6;0
WireConnection;135;1;136;0
WireConnection;249;0;244;0
WireConnection;249;1;245;0
WireConnection;248;0;243;0
WireConnection;15;0;16;0
WireConnection;251;0;246;0
WireConnection;251;1;249;0
WireConnection;250;0;279;0
WireConnection;250;1;248;0
WireConnection;85;0;86;0
WireConnection;85;1;15;0
WireConnection;7;0;5;0
WireConnection;7;1;135;0
WireConnection;14;0;85;0
WireConnection;14;1;7;0
WireConnection;252;0;250;0
WireConnection;252;1;251;0
WireConnection;3;0;14;0
WireConnection;364;0;252;0
WireConnection;376;0;375;1
WireConnection;376;1;375;3
WireConnection;8;0;3;0
WireConnection;144;0;74;0
WireConnection;144;1;143;0
WireConnection;75;0;79;0
WireConnection;366;0;8;0
WireConnection;194;9;365;0
WireConnection;194;3;197;0
WireConnection;194;4;198;0
WireConnection;377;0;376;0
WireConnection;377;1;378;0
WireConnection;374;0;377;0
WireConnection;76;0;80;0
WireConnection;76;1;144;0
WireConnection;87;0;145;0
WireConnection;87;1;75;0
WireConnection;211;0;194;1
WireConnection;193;0;192;0
WireConnection;240;0;211;0
WireConnection;240;1;241;0
WireConnection;320;0;319;0
WireConnection;369;0;193;0
WireConnection;369;1;370;0
WireConnection;77;0;87;0
WireConnection;77;1;76;0
WireConnection;379;0;374;0
WireConnection;318;0;240;0
WireConnection;318;1;320;0
WireConnection;318;2;379;0
WireConnection;346;1;356;1
WireConnection;346;2;356;2
WireConnection;346;3;356;3
WireConnection;255;0;252;0
WireConnection;371;0;369;0
WireConnection;78;0;77;0
WireConnection;239;0;238;0
WireConnection;258;0;255;0
WireConnection;257;0;254;0
WireConnection;213;0;212;0
WireConnection;149;0;78;0
WireConnection;210;0;371;0
WireConnection;210;1;204;0
WireConnection;210;2;318;0
WireConnection;349;0;346;0
WireConnection;349;1;350;0
WireConnection;348;0;210;0
WireConnection;348;1;349;0
WireConnection;151;0;213;0
WireConnection;151;1;149;0
WireConnection;151;2;148;0
WireConnection;259;0;257;0
WireConnection;259;1;258;0
WireConnection;259;2;256;0
WireConnection;123;0;239;0
WireConnection;123;1;125;0
WireConnection;123;2;8;0
WireConnection;174;0;172;0
WireConnection;152;0;123;0
WireConnection;152;1;151;0
WireConnection;152;2;259;0
WireConnection;172;0;169;0
WireConnection;355;0;348;0
WireConnection;368;2;355;0
WireConnection;368;11;152;0
ASEEND*/
//CHKSM=D64EF6BB7F653D27CB4875B137BDA4AA2140D659
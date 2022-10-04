// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shaders/EarthShader_JoseMiguelRuizMata"
{
	Properties
	{
		_IntensidadDeLaSombra("IntensidadDeLaSombra", Range( 0 , 10)) = 0
		_PowerFresnel("PowerFresnel", Range( 0 , 10)) = 0
		_ScaleFresnel("ScaleFresnel", Range( 0 , 10)) = 0
		_LadoDeLuzdelaTierra("LadoDeLuzdelaTierra", 2D) = "white" {}
		_LadoOscuroTierra("LadoOscuroTierra", 2D) = "white" {}
		_RimlightEarthColor("RimlightEarthColor", Color) = (0.0514238,0.001210371,0.3207547,0)
		_DarkSideIntensity("DarkSideIntensity", Range( 0 , 10)) = 0
		_LightNight("LightNight", 2D) = "white" {}
		_LightNightIntensity("LightNightIntensity", Range( 0 , 100)) = 0
		_MaskMapOcean("MaskMapOcean", 2D) = "white" {}
		_OceanSmoothness("OceanSmoothness", Range( 0 , 1)) = 0
		_LandSmoothness("LandSmoothness", Range( 0 , 1)) = 0
		[Normal]_NormalEarth("NormalEarth", 2D) = "bump" {}
		_NormalIntensity("NormalIntensity", Range( 0 , 5)) = 0
		_SpeedRotationEarth("SpeedRotationEarth", Range( 0 , 1)) = 0
		_nubes("nubes", 2D) = "white" {}
		_DarkSideNube("DarkSideNube", Range( 0 , 1)) = 0
		_intensidadNube("intensidadNube", Range( 0 , 2)) = 0
		_NubeVelocidad("NubeVelocidad", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _NormalEarth;
		uniform float _SpeedRotationEarth;
		uniform float _NormalIntensity;
		uniform sampler2D _LadoDeLuzdelaTierra;
		uniform sampler2D _LadoOscuroTierra;
		uniform float _IntensidadDeLaSombra;
		uniform sampler2D _nubes;
		uniform float _NubeVelocidad;
		uniform float _DarkSideNube;
		uniform float _intensidadNube;
		uniform float _DarkSideIntensity;
		uniform float _ScaleFresnel;
		uniform float _PowerFresnel;
		uniform float4 _RimlightEarthColor;
		uniform sampler2D _LightNight;
		uniform float _LightNightIntensity;
		uniform float _LandSmoothness;
		uniform float _OceanSmoothness;
		uniform sampler2D _MaskMapOcean;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime64 = _Time.y * _SpeedRotationEarth;
			float2 panner67 = ( mulTime64 * float2( 1,0 ) + i.uv_texcoord);
			o.Normal = UnpackScaleNormal( tex2D( _NormalEarth, panner67 ), _NormalIntensity );
			float3 ase_worldPos = i.worldPos;
			float clampResult38 = clamp( ( ase_worldPos.x * _IntensidadDeLaSombra ) , 0.0 , 1.0 );
			float4 lerpResult36 = lerp( tex2D( _LadoDeLuzdelaTierra, panner67 ) , tex2D( _LadoOscuroTierra, panner67 ) , clampResult38);
			float mulTime82 = _Time.y * _NubeVelocidad;
			float2 panner83 = ( mulTime82 * float2( 1,0 ) + i.uv_texcoord);
			float4 tex2DNode68 = tex2D( _nubes, panner83 );
			float4 lerpResult73 = lerp( tex2DNode68 , ( tex2DNode68 * _DarkSideNube ) , clampResult38);
			o.Albedo = ( lerpResult36 + lerpResult73 ).rgb;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV30 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode30 = ( 0.0 + _ScaleFresnel * pow( 1.0 - fresnelNdotV30, _PowerFresnel ) );
			float4 temp_output_40_0 = ( fresnelNode30 * _RimlightEarthColor );
			float4 lerpResult41 = lerp( ( _DarkSideIntensity * temp_output_40_0 ) , temp_output_40_0 , clampResult38);
			o.Emission = ( ( _intensidadNube * lerpResult73 ) + ( lerpResult41 + ( clampResult38 * ( tex2D( _LightNight, panner67 ) * _LightNightIntensity ) ) ) ).rgb;
			float lerpResult56 = lerp( _LandSmoothness , _OceanSmoothness , tex2D( _MaskMapOcean, panner67 ).r);
			o.Smoothness = lerpResult56;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Version=18934
181.6;73.6;935.6;555.8;3046.715;443.2687;3.447767;True;True
Node;AmplifyShaderEditor.RangedFloatNode;80;-1545.223,409.0605;Inherit;False;Property;_NubeVelocidad;NubeVelocidad;18;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2187.227,860.9686;Inherit;False;Property;_SpeedRotationEarth;SpeedRotationEarth;14;0;Create;True;0;0;0;False;0;False;0;0.06;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2246.465,-342.6907;Float;False;Property;_ScaleFresnel;ScaleFresnel;2;0;Create;True;0;0;0;False;0;False;0;0.4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2236.065,-228.2912;Float;False;Property;_PowerFresnel;PowerFresnel;1;0;Create;True;0;0;0;False;0;False;0;2.16;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;-1276.615,179.7791;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;82;-1239.281,414.6657;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-1891.844,628.9089;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;64;-1854.51,863.796;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;67;-1628.572,684.6642;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;83;-987.656,249.6917;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;39;-1894.679,-218.1421;Inherit;False;Property;_RimlightEarthColor;RimlightEarthColor;5;0;Create;True;0;0;0;False;0;False;0.0514238,0.001210371,0.3207547,0;0.05727128,0.07255391,0.3113208,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;30;-1894.594,-500.295;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-788.6731,-896.7876;Float;False;Property;_IntensidadDeLaSombra;IntensidadDeLaSombra;0;0;Create;True;0;0;0;False;0;False;0;8.4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-699.1062,-1062.905;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;75;-801.7104,664.0953;Inherit;False;Property;_DarkSideNube;DarkSideNube;16;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-664.6833,266.6588;Inherit;True;Property;_nubes;nubes;15;0;Create;True;0;0;0;False;0;False;-1;262d3dc173ccb0f449b223a739740b57;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1562.401,-402.6491;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;44;-1633.287,-192.1331;Inherit;True;Property;_LightNight;LightNight;7;0;Create;True;0;0;0;False;0;False;-1;None;3241ad180955c9a42b765f347156099c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1869.668,-610.3069;Inherit;False;Property;_DarkSideIntensity;DarkSideIntensity;6;0;Create;True;0;0;0;False;0;False;0;0.2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-350.0386,-1039.184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1020.631,86.49939;Inherit;False;Property;_LightNightIntensity;LightNightIntensity;8;0;Create;True;0;0;0;False;0;False;0;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1449.843,-575.6492;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1180.852,-145.5168;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;38;-81.18457,-801.4718;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-306.9889,351.9019;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;37;-308.4344,-1276.998;Inherit;True;Property;_LadoOscuroTierra;LadoOscuroTierra;4;0;Create;True;0;0;0;False;0;False;-1;None;3241ad180955c9a42b765f347156099c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-477.5848,30.48271;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;73;-236.2967,219.8184;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-656.1636,487.9734;Inherit;False;Property;_intensidadNube;intensidadNube;17;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;41;-1126.579,-532.2712;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;35;-305.8844,-1485.809;Inherit;True;Property;_LadoDeLuzdelaTierra;LadoDeLuzdelaTierra;3;0;Create;True;0;0;0;False;0;False;-1;None;e3aeb29228f1f414b805a7b1d5a095c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-818.8584,-244.0578;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;36;95.16758,-1168.391;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-796.5239,-384.9308;Float;False;Property;_NormalIntensity;NormalIntensity;13;0;Create;True;0;0;0;False;0;False;0;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1118.233,896.6647;Inherit;False;Property;_LandSmoothness;LandSmoothness;11;0;Create;True;0;0;0;False;0;False;0;0.257;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;-1116.225,696.3541;Inherit;True;Property;_MaskMapOcean;MaskMapOcean;9;0;Create;True;0;0;0;False;0;False;-1;None;cd319c205339e374992c0a3829aecc27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;-1089.337,1017.6;Inherit;False;Property;_OceanSmoothness;OceanSmoothness;10;0;Create;True;0;0;0;False;0;False;0;0.302;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-77.56123,337.463;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;56;-537.8914,765.0994;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-59.38322,-30.77259;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;104.6224,171.7204;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;60;-501.2813,-520.6227;Inherit;True;Property;_NormalEarth;NormalEarth;12;1;[Normal];Create;True;0;0;0;False;0;False;60;None;c02df36e1ea4d804e884fd6e22d3bff9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;11;240.0797,57.32009;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Shaders/EarthShader_JoseMiguelRuizMata;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;82;0;80;0
WireConnection;64;0;65;0
WireConnection;67;0;66;0
WireConnection;67;1;64;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;30;2;32;0
WireConnection;30;3;31;0
WireConnection;68;1;83;0
WireConnection;40;0;30;0
WireConnection;40;1;39;0
WireConnection;44;1;67;0
WireConnection;28;0;27;1
WireConnection;28;1;29;0
WireConnection;42;0;43;0
WireConnection;42;1;40;0
WireConnection;48;0;44;0
WireConnection;48;1;49;0
WireConnection;38;0;28;0
WireConnection;74;0;68;0
WireConnection;74;1;75;0
WireConnection;37;1;67;0
WireConnection;50;0;38;0
WireConnection;50;1;48;0
WireConnection;73;0;68;0
WireConnection;73;1;74;0
WireConnection;73;2;38;0
WireConnection;41;0;42;0
WireConnection;41;1;40;0
WireConnection;41;2;38;0
WireConnection;35;1;67;0
WireConnection;51;0;41;0
WireConnection;51;1;50;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;36;2;38;0
WireConnection;55;1;67;0
WireConnection;78;0;77;0
WireConnection;78;1;73;0
WireConnection;56;0;59;0
WireConnection;56;1;58;0
WireConnection;56;2;55;0
WireConnection;76;0;36;0
WireConnection;76;1;73;0
WireConnection;71;0;78;0
WireConnection;71;1;51;0
WireConnection;60;1;67;0
WireConnection;60;5;61;0
WireConnection;11;0;76;0
WireConnection;11;1;60;0
WireConnection;11;2;71;0
WireConnection;11;4;56;0
ASEEND*/
//CHKSM=3794F7A70E5BCC157D74C7D998F6B83F131D5241
Shader "SystemFont" {
	Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
		_MainTex ("Font Texture", 2D) = "white" {}
	}

	SubShader {
		Tags {
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
		}
		Lighting Off
		Cull Off
		ZWrite On
		Fog {Mode Off}
		Blend SrcAlpha OneMinusSrcAlpha
		Pass {
			SetTexture [_MainTex] {
				constantColor [_Color]
				Combine constant, texture * constant
			}
		}
	}
}

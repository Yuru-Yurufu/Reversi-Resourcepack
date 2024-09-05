#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in float depthLevel;
in vec4 vertexColor;
in vec2 texCoord0;

in vec3 ColorValue;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

	if (color.a < 0.1) {
		discard;
	}

	// titleの影を消す
	if (ColorValue.r == 6 && (depthLevel == 2400.00 || depthLevel == 2200.00)) {
		discard;
	}

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}

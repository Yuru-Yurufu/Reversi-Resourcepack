#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

out float depthLevel;

out vec3 ColorValue;

void main() {
    // 透明度だけ引き継いだ白色
    vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
    white.w = Color.w;

    depthLevel = Position.z;

    // RGBを整数値で取得
    ColorValue = vec3(round(Color.r * 255.0), round(Color.g * 255.0), round(Color.b * 255.0));

    vec3 pos = Position;
    if (ColorValue.r == 24.0 && depthLevel == 0.12) {
        // title
        if (ColorValue.g == 24.0) {
            pos.y -= 100.0;
        }
        vertexColor = white * texelFetch(Sampler2, UV2 / 16, 0);
    } else if (ColorValue.r == 24.0 && depthLevel == 0.06) {
        // subtitle
        if (ColorValue.g == 24.0) {
            pos.y -= 2.0;
        }
        pos.z += 0.1;
        vertexColor = white * texelFetch(Sampler2, UV2 / 16, 0);
    } else if (ColorValue.r == 24.0 && depthLevel == 0.03) {
        // actionbar
        if (ColorValue.g == 24.0) {
            pos.y -= 200.0;
            if ((ColorValue.b >= 112.0) && (ColorValue.b <= 144.0)) {
                pos.x += ((ColorValue.b - 128.0) / 20);
            }
        }
        pos.z += 0.1;
        vertexColor = white * texelFetch(Sampler2, UV2 / 16, 0);
    } else if (ColorValue.r == 25.0 && depthLevel == 0.03) {
        pos.y += 40.0;
        pos.z += 0.1;

        int temp = int(GameTime * 60000) % 60;
        if (temp <= 49) {
            white.w = sin(temp * 0.314159265 / 6);
        } else {
            white.w = 0.0;
        }
        vertexColor = white * texelFetch(Sampler2, UV2 / 16, 0);
    } else if (ColorValue.r == 26.0 && depthLevel == 0.03) {
        pos.y += 40.0;
        pos.z += 0.1;
        white.w = sin(int(GameTime * 60000) % 60 * 0.314159265 / 6);
        vertexColor = white * texelFetch(Sampler2, UV2 / 16, 0);
    } else {
        // その他
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    }

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    texCoord0 = UV0;
}

#define MAX_STEPS 100
#define MAX_DIST 60.0
#define EPS 0.001

float sdSphere(vec3 p, float r)
{
    return length(p) - r;
}

float map(vec3 p)
{
    float d = sdSphere(p - vec3(0.0, 1.0, 0.0), 1.0);
    return min(d, p.y);
}

vec3 calcNormal(vec3 p)
{
    vec2 e = vec2(EPS, 0.0);
    return normalize(vec3(map(p + e.xyy) - map(p - e.xyy),
                          map(p + e.yxy) - map(p - e.yxy),
                          map(p + e.yyx) - map(p - e.yyx)));
}

vec3 shade(vec3 ro, vec3 rd)
{
    vec3 sky = vec3(0.45, 0.6, 0.8);
    float t = march(ro, rd);
    if (t > MAX_DIST)
        return sky;

    vec3 p = ro + rd * t;
    vec3 n = calcNormal(p);
    vec3 light = normalize(vec3(0.6, 0.8, -0.4));
    float diff = clamp(dot(n, light), 0.0, 1.0);
    vec3 albedo = vec3(0.8, 0.35, 0.25);
    vec3 col = albedo * (0.15 + 0.85 * diff);
    return col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    vec3 ro = vec3(0.0, 1.5, -4.0);
    vec3 rd = normalize(vec3(uv, 1.5));
    vec3 col = shade(ro, rd);
    fragColor = vec4(col, 1.0);
}

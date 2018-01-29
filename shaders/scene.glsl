#define MAX_STEPS 100
#define MAX_DIST 60.0
#define EPS 0.001

float sdSphere(vec3 p, float r)
{
    return length(p) - r;
}

float sdBox(vec3 p, vec3 b)
{
    vec3 d = abs(p) - b;
    return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

float smin(float a, float b, float k)
{
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

float map(vec3 p)
{
    float d = sdSphere(p - vec3(0.0, 1.0, 0.0), 1.0);
    d = smin(d, sdBox(p - vec3(1.1, 0.5, 0.0), vec3(0.5)), 0.3);
    return min(d, p.y);
}

float march(vec3 ro, vec3 rd)
{
    float t = 0.0;
    for (int i = 0; i < MAX_STEPS; i++) {
        float d = map(ro + rd * t);
        if (d < EPS || t > MAX_DIST)
            break;
        t += d;
    }
    return t;
}

vec3 calcNormal(vec3 p)
{
    vec2 e = vec2(EPS, 0.0);
    return normalize(vec3(map(p + e.xyy) - map(p - e.xyy),
                          map(p + e.yxy) - map(p - e.yxy),
                          map(p + e.yyx) - map(p - e.yyx)));
}

float softShadow(vec3 ro, vec3 rd, float k)
{
    float res = 1.0;
    float t = 0.02;
    for (int i = 0; i < 48; i++) {
        float h = map(ro + rd * t);
        res = min(res, k * h / t);
        t += clamp(h, 0.02, 0.5);
        if (res < 0.001 || t > 20.0)
            break;
    }
    return clamp(res, 0.0, 1.0);
}

float calcAO(vec3 p, vec3 n)
{
    float occ = 0.0;
    float sca = 1.0;
    for (int i = 0; i < 5; i++) {
        float h = 0.01 + 0.12 * float(i) / 4.0;
        occ += (h - map(p + h * n)) * sca;
        sca *= 0.95;
    }
    return clamp(1.0 - 3.0 * occ, 0.0, 1.0);
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
    diff *= softShadow(p + n * 0.01, light, 12.0);
    float ao = calcAO(p, n);
    vec3 albedo = vec3(0.8, 0.35, 0.25);
    vec3 col = albedo * (0.15 * ao + 0.85 * diff);
    return col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float a = iMouse.x / iResolution.x * 6.2831;
    vec3 ro = vec3(5.0 * sin(a), 2.0, -5.0 * cos(a));
    vec3 ta = vec3(0.0, 0.8, 0.0);
    vec3 ww = normalize(ta - ro);
    vec3 uu = normalize(cross(ww, vec3(0.0, 1.0, 0.0)));
    vec3 vv = cross(uu, ww);
    vec3 col = vec3(0.0);
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    vec3 rd = normalize(uv.x * uu + uv.y * vv + 1.5 * ww);
    col = shade(ro, rd);
    col = pow(col, vec3(1.0 / 2.2));
    fragColor = vec4(col, 1.0);
}

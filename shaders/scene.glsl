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

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    vec3 ro = vec3(0.0, 1.5, -4.0);
    vec3 rd = normalize(vec3(uv, 1.5));
    vec3 col = shade(ro, rd);
    fragColor = vec4(col, 1.0);
}

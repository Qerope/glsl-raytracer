
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    vec3 ro = vec3(0.0, 1.0, -4.0);
    vec3 rd = normalize(vec3(uv, 1.5));
    float b = dot(ro, rd);
    float c = dot(ro, ro) - 1.0;
    float h = b * b - c;
    vec3 col = vec3(0.1);
    if (h > 0.0) {
        float t = -b - sqrt(h);
        vec3 n = normalize(ro + rd * t);
        col = n * 0.5 + 0.5;
    }
    fragColor = vec4(col, 1.0);
}

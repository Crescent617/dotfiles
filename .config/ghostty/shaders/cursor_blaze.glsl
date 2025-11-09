// configuration
const vec4 TRAIL_COLOR = vec4(0.678, 0.847, 0.902, 1.0);
const vec4 TRAIL_COLOR_ACCENT = vec4(0.0, 0.3, 1.0, 1.0);
const float DURATION = .5;
// Don't draw trail within that distance * cursor size.
// This prevents trails from appearing when typing.
const float DRAW_THRESHOLD = 1.5;
// Don't draw trails within the same line: same line jumps are usually where
// people expect them.
const bool HIDE_TRAILS_ON_SAME_LINE = false;

float ease(float x) {
    return pow(1.0 - x, 3.0);
}

// SDF: Signed Distance Function for rectangle
// 表示一个点到矩形边界的距离，负值表示点在矩形内部，正值表示点在矩形外部
float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}
// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float blend(float t)
{
    // float sqr = t * t;
    // return sqr / (2.0 * (sqr - t) + 1.0);
    return t;
}

float antialising(float d) {
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, d);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    // Conditions using step
    float condition1 = step(b.x, a.x) * step(a.y, b.y); // a.x >= b.x and a.y <= b.y
    float condition2 = step(a.x, b.x) * step(b.y, a.y); // a.x <= b.x and a.y >= b.y

    // If neither condition is met, return 1 (else case)
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    float progress = (iTime - iTimeCursorChange) / DURATION;
    // Only draw trail if within duration
    if (progress < 0.0 || progress > 1.0) {
        return;
    }

    //Normalization for fragCoord to a space of -1 to 1;
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-0.5, 0.5);

    //Normalization for cursor position and size;
    //cursor xy has the postion in a space of -1 to 1;
    //zw has the width and height
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    //When drawing a parallelogram between cursors for the trail i need to determine where to start at the top-left or top-right vertex of the cursor
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    //Set every vertex of my parellogram
    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    progress = ease(blend(clamp(progress, 0.0, 1)));

    //Distance between cursors determine the total length of the parallelogram;
    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    float cursorSize = max(currentCursor.z, currentCursor.w);
    float trailThreshold = DRAW_THRESHOLD * cursorSize;
    float lineLength = distance(centerCC, centerCP);

    bool isFarEnough = lineLength > trailThreshold || (HIDE_TRAILS_ON_SAME_LINE && currentCursor.y != previousCursor.y);
    if (isFarEnough) {
        vec4 newColor = vec4(fragColor);

        float distanceToEnd = distance(vu.xy, centerCC);
        float alphaModifier = clamp(distanceToEnd / (lineLength * progress), 0.0, 1.0);

        float sdfCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
        float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

        newColor = mix(newColor, TRAIL_COLOR_ACCENT, 1.0 - smoothstep(sdfTrail, -0.003, 0.001));
        newColor = mix(newColor, TRAIL_COLOR, antialising(sdfTrail));
        newColor = mix(fragColor, newColor, 1.0 - alphaModifier);
        fragColor = mix(newColor, fragColor, step(sdfCursor, 0));
    }
}

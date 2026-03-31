// Simple hash function for procedural noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D Noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void MAIN() {
    // Generate the "Brushed" texture
    vec2 brushUV = UV0 * vec2(brushScale, brushScale * brushFlow);
    float n = noise(brushUV);
    
    // Perturb the Normal slightly for anisotropic highlights
    float scratch = (n - 0.5) * brushStrength;
    vec3 perturbedNormal = normalize(NORMAL + TANGENT * scratch);
    
    // Set PBR properties
    BASE_COLOR = vec4(baseColor.rgb, 1.0);
    METALNESS = metalness;
    ROUGHNESS = clamp(roughness + (n * 0.05), 0.0, 1.0);
    NORMAL = perturbedNormal;

    // FAKE REFLECTIONS (Matcap-like)
    vec3 viewDir = normalize(VIEW_VECTOR);
    vec3 reflectDir = reflect(viewDir, perturbedNormal);
    
    // Gradient sky to make flat surfaces less "solid white"
    // Silvery top, slightly darker horizon
    vec3 skyTop = vec3(1.0, 1.0, 1.0);
    vec3 skyHorizon = vec3(0.6, 0.6, 0.65);
    vec3 groundColor = vec3(0.02, 0.02, 0.03);
    
    float horizonFactor = reflectDir.y * 0.5 + 0.5;
    vec3 skyGradient = mix(skyHorizon, skyTop, pow(max(0.0, reflectDir.y), 0.5));
    
    // Mask by normal: surfaces pointing down should see ground
    float normalMask = smoothstep(-0.4, 0.2, NORMAL.y);
    vec3 reflection = mix(groundColor, skyGradient, horizonFactor * normalMask);
    
    // Fresnel-like effect: reflections are stronger at glancing angles
    float fresnel = 0.1 + 0.9 * pow(1.0 - max(0.0, dot(NORMAL, viewDir)), 3.0);
    
    // Sharp sun highlight
    float sun = pow(max(0.0, dot(reflectDir, normalize(vec3(0.5, 1.0, 0.5)))), 128.0);
    reflection += vec3(0.8) * sun;

    // Apply reflection
    EMISSIVE_COLOR = reflection * reflectivity * metalness * fresnel * nightAlpha;
}

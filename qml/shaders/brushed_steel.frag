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

    // Add more variation with different frequencies
    float detailNoise = noise(UV0 * brushScale * 0.3) * 0.3;
    float combinedNoise = n * 0.7 + detailNoise;

    // Perturb the Normal slightly for anisotropic highlights
    float scratch = (n - 0.5) * brushStrength;
    vec3 perturbedNormal = normalize(NORMAL + TANGENT * scratch);

    // Vary roughness based on noise for brushed steel appearance
    // Keep it low for metallic shine that responds to scene lights
    float roughnessVariation = combinedNoise * 0.05;

    // Use the baseColor property with only ADDITIVE variation (no darkening)
    vec3 steelColor = baseColor.rgb + vec3(combinedNoise * 0.03);

    // Set PBR properties - these respond to scene lighting (sun/spotlights)
    BASE_COLOR = vec4(steelColor, baseColor.a); // Preserve alpha
    METALNESS = metalness; // High metalness makes it reflect lights properly
    ROUGHNESS = clamp(roughness + roughnessVariation, 0.06, 0.20);
    NORMAL = perturbedNormal;

    // Brighter ambient reflection to help visibility
    vec3 viewDir = normalize(VIEW_VECTOR);
    vec3 reflectDir = reflect(viewDir, perturbedNormal);

    // Bright ambient environment for shiny steel
    vec3 ambient = vec3(0.5, 0.52, 0.55);
    float horizonFactor = reflectDir.y * 0.5 + 0.5;
    vec3 ambientReflection = ambient * horizonFactor;

    // Light fresnel edge glow
    float fresnel = pow(1.0 - max(0.0, dot(perturbedNormal, viewDir)), 3.0);

    // Bright emissive for shiny steel look
    EMISSIVE_COLOR = ambientReflection * reflectivity * fresnel * 0.45 * nightAlpha;
}

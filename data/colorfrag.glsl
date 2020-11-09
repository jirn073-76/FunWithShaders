#ifdef GL_ES
precision mediump float;
#endif

uniform float uTime; // time in milliseconds
uniform vec2 uResolution;
int i = 0;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
  vec2 coord = gl_FragCoord.xy;

  for (int n = 1; n < 8; n++){
    float i = float(n);
    coord += vec2(0.7 / i * sin(i * coord.y + uTime + 0.3 * i) + 0.8, 0.4 / i * sin(coord.x + uTime + 0.3 * i) + 1.6);
  }

  coord += vec2(0.7 / sin(coord.y + uTime + 0.3) + 0.8, 0.4 / sin(coord.x + uTime + 0.3) + 1.6);

  vec3 color = vec3(0.5 * sin(coord.x) + 0.5, 0.5 * sin(coord.y) + 0.5, sin(coord.x + coord.y));

  gl_FragColor = vec4(color, 1.0);
}
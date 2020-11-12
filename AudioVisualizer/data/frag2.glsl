#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float u_time;
uniform float colorMult;
uniform int width;
uniform int height;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
  vec2 coord = 6.0 * gl_FragCoord.xy / vec2(width,height); // / u_resolution;
  for (int n = 1; n < 2; n++){
    float i = float(n);
    coord *= vec2(0.7 / i * sin(i * coord.y + u_time + 0.3 * i) + 0.8, 0.1 / i * sin(coord.x + u_time + 0.3 * i) + 1.6);
  }

  coord += vec2(0.7 / sin(coord.y + u_time + 0.3) + 0.8, 0.4 / sin(coord.x + u_time + 0.3) + 1.6);

  //vec3 color = vec3(0.5 * sin(coord.x) + 0.5, 0.5 * sin(coord.y) + 0.5, sin(coord.x + coord.y));
  //vec3 color = rgb2hsv(vec3(sin(coord.x + coord.y),255,255))

  gl_FragColor = vec4(hsv2rgb(vec3(sin(coord.x + coord.y),sin(coord.x + coord.y),sin(coord.x + coord.y))), 1.);
}
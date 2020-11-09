PShape can;
float angle;
PShader colorShader;
float time = 0f;

void setup() {
  fullScreen(P3D);
  can = createCan(400, 400, 10);
  //can = createSimple();
  colorShader = loadShader("frag2.glsl", "colorvert.glsl");
}

void draw() {
  background(0);
  colorShader.set("u_time", time += 0.05f);
  shader(colorShader);
  translate(width/2, height/2);
  rotateY(angle);
  rotateX(angle);
  shape(can);
  angle += 0.01;
}

PShape createSimple() {
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.vertex(0,0);
  sh.vertex(1,0);
  sh.vertex(0,1);
  sh.vertex(1,1);
  sh.endShape();
  return sh;
}

PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  //sh.noStroke();
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape();
  return sh;
}

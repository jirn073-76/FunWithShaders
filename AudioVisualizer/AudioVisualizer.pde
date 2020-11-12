import android.media.audiofx.Visualizer;

PShader colorShader;
Visualizer vis;
int captureRate;
Band[] bands = new Band[512];
int bassRange = 5;
float scoreLow = 0;
float time = 0f;
float r = 0;
int c = 0;

void setup() {
  fullScreen(P2D);
  colorShader = loadShader("colorfrag.glsl", "colorvert.glsl");
  colorShader.set("width", (float) width);
  colorShader.set("height", (float) height);
  background(0);
  strokeWeight(10);
  colorMode(HSB);
  noFill();
  stroke(255);
  for (int i = 0; i < bands.length; i++) {
    bands[i] = new Band();
  }
  vis = new Visualizer(0);
  vis.setEnabled(false);
  vis.setCaptureSize(Visualizer.getCaptureSizeRange()[1]);
  Visualizer.OnDataCaptureListener captureListener = new Visualizer.OnDataCaptureListener()
  {
    @Override
      public void onWaveFormDataCapture(Visualizer visualizer, byte[] bytes, int samplingRate)
    {
    }

    @Override
      public void onFftDataCapture(Visualizer visualizer, byte[] bytes, int samplingRate)
    {
      //println(log10(1)*Math.abs(bytes[0]));
      for (int i = 0; i < bands.length; i++) {
        float t;
        t = bytes[i] * (0.54f - 0.46f*(float)Math.cos((2f*Math.PI*i)/ (float)Visualizer.getMaxCaptureRate()));
        t = 50.0 * log10((bytes[i * 2] * bytes[i * 2]) + (bytes[i * 2 + 1] * bytes[i * 2 + 1])+1);
        //println(t);
        bands[i].setTarget(t);
        if (i < bassRange) {
          scoreLow = 0;
          //scoreLow += bytes[i];
        }
      }
      //scoreLow *= 2;
    }
  };
  vis.setDataCaptureListener(captureListener, Visualizer.getMaxCaptureRate(), false, true);
  vis.setEnabled(true);
}

void draw() {
  background(0);
  colorShader.set("uTime", time += 0.01f);
  shader(colorShader);
  translate(width/2, height/2);
  rotate(-HALF_PI);
  r = lerp(r, 300+scoreLow, 0.3);
  if (c > 255) {
    c=0;
  }
  beginShape();
  for (int i = 0; i < bands.length; i++) {
    //stroke((map(i, 0, bands.length-1, 0, 255)+c)%255, 255, 255);
    vertex((bands[i].getValue()+r)*cos(map(i, 0, bands.length-1, 0, PI)), (bands[i].getValue()+r)*sin(map(i, 0, bands.length-1, 0, PI)));
    bands[i].lerpValue();
  }

  for (int i = bands.length-1; i >= 0; i--) {
    //stroke((map(i, 0, bands.length-1, 0, 255)+c)%255, 255, 255);
    vertex((bands[i].getValue()+r)*cos(map(i, bands.length-1, 0, PI, TWO_PI)), (bands[i].getValue()+r)*sin(map(i, bands.length-1, 0, PI, TWO_PI)));
    bands[i].lerpValue();
  }
  endShape();
  c++;
}

float log10 (int x) {
  return (log(x) / log(10));
}



VertexCountListener vertexCountListener;
ThresholdListener thresholdListener;

void setupUI() {
  cp5 = new ControlP5(this);
  cp5.addSlider("edgeWidth")
    .setPosition(20, 300)
    .setRange(0.25, 3)
    ;

  cp5.addSlider("nodeSize")
    .setPosition(20, 320)
    .setRange(2, 15)
    ;

  cp5.addSlider("PROCESSING_INTERVAL")
    .setPosition(20, 340)
    .setRange(1, 200)
    ;

  cp5.addSlider("VERTEX_COUNT")
    .setPosition(20, 360)
    .setRange(1, 50000)
    ;

  cp5.addSlider("RGG_THRESHOLD")
    .setPosition(20, 380)
    .setRange(0.01, 0.5)
    ;

  cp5.addSlider("AVERAGE_DEGREE")
    .setPosition(20, 400)
    .setRange(1, 50)
    ;


  cp5.addToggle("USE_RGG_THRESHOLD")
    .setPosition(20, 420)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;


  vertexCountListener = new VertexCountListener();
  thresholdListener = new ThresholdListener();

  cp5.getController("VERTEX_COUNT").addListener(vertexCountListener);
  cp5.getController("RGG_THRESHOLD").addListener(thresholdListener);
  cp5.getController("USE_RGG_THRESHOLD").addListener(thresholdListener);
  cp5.getController("AVERAGE_DEGREE").addListener(thresholdListener);
}


class VertexCountListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    clearData();
    generateRGG();
  }
}

class ThresholdListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {

    updateRggThreshold();
    clearData();
    generateRGG();
  }
}
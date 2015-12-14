VertexCountListener vertexCountListener;
ThresholdListener thresholdListener;

void setupUI() {
  cp5 = new ControlP5(this);
  
  int h = 320;
  
  cp5.addSlider("edgeWidth")
    .setPosition(20, h += 20)
    .setRange(0.25, 3)
    ;

  cp5.addSlider("nodeSize")
    .setPosition(20, h += 20)
    .setRange(2, 15)
    ;

  cp5.addSlider("PROCESSING_INTERVAL")
    .setPosition(20, h += 20)
    .setRange(1, 200)
    ;
    
    cp5.addSlider("coverageOpacity")
    .setPosition(20, h += 20)
    .setRange(1, 100)
    ;
    
  cp5.addSlider("VERTEX_COUNT")
    .setPosition(20, h += 20)
    .setRange(1, 64000)
    ;

  cp5.addSlider("RGG_THRESHOLD")
    .setPosition(20, h += 20)
    .setRange(0.01, 2)
    ;

  cp5.addSlider("AVERAGE_DEGREE")
    .setPosition(20, h += 20)
    .setRange(1, 120)
    ;


  cp5.addToggle("USE_RGG_THRESHOLD")
    .setPosition(20, h += 20)
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
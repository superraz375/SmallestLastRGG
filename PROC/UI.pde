void setupUI() {
 cp5 = new ControlP5(this);
 cp5.addSlider("edgeWidth")
 .setPosition(20,300)
 .setRange(0.25,3)
;
     
cp5.addSlider("nodeSize")
.setPosition(20,320)
.setRange(2,15)
;

cp5.addSlider("PROCESSING_INTERVAL")
.setPosition(20,340)
.setRange(1,200)
;
}
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
  }
}


public void input(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'input' : "+theText);
}
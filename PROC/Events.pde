
// Adjust scale factor when zooming using a mouse wheel or trackpad
void mouseWheel(MouseEvent event) {  
  scaleFactor += (float) event.getCount() / 100;
  if (scaleFactor < MIN_SCALE) scaleFactor = MIN_SCALE;
  if (scaleFactor > MAX_SCALE) scaleFactor = MAX_SCALE;
}

void handleMouseEvents() {
  if(!allow3DRotate) {
    return;
  }
  
  rotateX(rotX);
  rotateY(rotY);
  
  if (mousePressed) {
    rotY += (pmouseX - mouseX) * -1 * ROTATION_DELTA;
    rotX += (pmouseY - mouseY) * ROTATION_DELTA;
  }
  
  // Rotate along Y axis
  if (rot) {
    rotY += ROTATION_DELTA;
  }
}

// Handle key presses and trigger different stages
void keyPressed() {
  if (key == '1') {
    clearData();
    currentShape = GraphShape.SPHERE;
    generateRGG();
  } else if (key == '2') {
    clearData();
    currentShape = GraphShape.DISK;
    generateRGG();
  } else if (key == '3') {
    clearData();
    currentShape = GraphShape.SQUARE;
    generateRGG();
  } else if ((key == 'p' || key == 'P') && rIndex < 0) {
    // PLOT
    currentStatus = GraphStage.PLOT;
    currentPlotType = PlotType.REMAINING_DEGREE;
  } else if (key == 'c' || key == 'C') {
    needsToUpdateBipartiteColorNodes = false;
    needsToUpdateColorNodes = true;
    currentStatus = GraphStage.COLOR_GRAPH;
  } else if ((key == 'o' || key == 'O') && rIndex < 0) {
    // PLOT
    currentStatus = GraphStage.PLOT;
    currentPlotType = PlotType.ORIGINAL_DEGREE;
  } else if ((key == 'v' || key == 'V') && rIndex < 0) {
    currentStatus = GraphStage.PLOT;
    currentPlotType = PlotType.AVERAGE_DEGREE;
  } else if ((key == 'a' || key == 'A') && rIndex < 0) {
    currentStatus = GraphStage.PLOT;
    currentPlotType = PlotType.ALL;
  } else if (key == 'l' || key == 'L') {
    if (rIndex >= 0 && highlightMinMaxDegreeNodes) {
      isHighlightEdges = !isHighlightEdges;
    } else if (showColorAsBipartite) {
      isHighlightEdges = !isHighlightEdges;
    } else {
      showEdges = !showEdges;
    }
  } else if (key == 's' || key == 'S') {
    // Start/stop processing
    isProcessing = !isProcessing;
  } else if (key == 'h' || key == 'H') {
    if (highlightMinMaxDegreeNodes) {
      highlightMinMaxDegreeNodes = false;
      showEdges = true;
    } else {
      highlightMinMaxDegreeNodes = true;
      showEdges = false;
    }
  } else if (key == 'w' || key == 'W') {
    if (finishedColoring) {
      if (all) {
        needsToUpdateBipartiteColorNodes = false;
        needsToUpdateColorNodes = true;
        all = false;
      } else {
        needsToUpdateBipartiteColorNodes = false;
        needsToUpdateColorNodes = true;
        showColorAsBipartite = false;
        aPlace = 0;
        bPlace = 0;
        cCount = 1;
        all = true;
      }
    }
  } else if (key == CODED) {
    if (!all) {
      if (keyCode == RIGHT) {
        if(showColorAsBipartite) {
        showColorAsBipartite = false;
        needsToUpdateColorNodes = true;
        aPlace = 0;
        bPlace = 1;
        } else {
          aPlace = (aPlace + 1) % (maximum + 1);
          needsToUpdateColorNodes = true;
        }
      } else if (keyCode == LEFT) {
        if(showColorAsBipartite) {
        showColorAsBipartite = false;
        needsToUpdateColorNodes = true;
        aPlace = 0;
        bPlace = 1;
        } else {
          aPlace--;
          if(aPlace < 0) {
           aPlace = maximum; 
          }
          needsToUpdateColorNodes = true;
        }
      } else if (keyCode == UP) {
        if (!showColorAsBipartite) {
          needsToUpdateColorNodes = false;
          needsToUpdateBipartiteColorNodes = true;
          showColorAsBipartite = true;
          aPlace = 0;
          bPlace = 1;
          cCount = 1;
        } else if (cCount < maximum * (maximum + 1) / 2) {
          needsToUpdateBipartiteColorNodes = true;
          bPlace++;
          if (bPlace == maximum + 1) {
            bPlace = 0;
            aPlace++;
          }

          while (bPlace <= aPlace) {
            bPlace++;
          }
          cCount++;
        }
      } else if (keyCode == DOWN) {
        if (!showColorAsBipartite) {
          needsToUpdateColorNodes = false;
          needsToUpdateBipartiteColorNodes = true;
          showColorAsBipartite = true;
          aPlace = 0;
          bPlace = 1;
          cCount = 1;
        } else if (cCount > 1) {
          needsToUpdateBipartiteColorNodes = true;
          bPlace--;
          while (bPlace <= aPlace) {
            bPlace--;
            if (bPlace == -1) {
              bPlace = maximum;
              aPlace--;
            }
          }
          cCount--;
        }
      }
    }
  } else if (key == 'r' || key == 'R') {
    // Rotate graph along Y axis
    rot = !rot;
  } else if (key == 'x' || key == 'X') {
    // Capture Screenshot
    capture = true;
  }
}
void drawStage1Text() {
  textAlign(LEFT);
  fill(255, 255, 255);

  int h = 0;
  text("Progress: " + (100 - (rIndex + 1.0) / VERTEX_COUNT * 100) + "%", 15, h+=20);
  text("Vertex count: " + (rIndex + 1), 15, h+=20);
  text("Edge count: " + (edgeCount), 15, h+=20);

  h += 20;

  text("Threshold: " + nf(RGG_THRESHOLD, 0, 3), 15, h+=20);
  text("Average Degree: " + nf(graphAverageDegree, 0, 2), 15, h+=20);
  text("Rotate: " + (rot && allow3DRotate ? "ON" : "OFF"), 15, h+=20);
  text("Processing: " + (isProcessing ? "ON" : "OFF"), 15, h+=20);
  text("Edge: " + (showEdges ? "ON": "OFF"), 15, h+=20);


  text("Highlight Min/Max Nodes: " + (highlightMinMaxDegreeNodes && maximum >= 0 ? "ON" : "OFF"), 15, h+=20);
  if (highlightMinMaxDegreeNodes && maximum >= 0) {

    h += 20;

    fill(0, 255, 0);
    text("Minimum degree: " + (minimum), 15, h+=20);
    text("Amount: " + (minAmount), 15, h+=20);
    fill(255, 0, 255);
    text("Maximum degree: " + (maximum), 15, h+=20);
    text("Amount: " + (maxAmount), 15, h+=20);
    fill(0, 0, 255);
    text("Highlight edge: " + (isHighlightEdges ? "ON" : "OFF"), 15, h+=20);
  }
}

void drawControlText() {
  background(0);
  fill(255, 0, 0);
  textAlign(LEFT);
  int h = 0;
  int w = width - 240;
  text("Smallest Last Ordering: " + currentShape, w, h+=20);
  fill(255);
  h+= 20;

  text("Mode:", w, h+= 20);
  text("Key '1': Sphere", w, h+= 20);
  text("Key '2': Disk", w, h+= 20);
  text("Key '3': Square", w, h+= 20);

  h += 20;
  text("Controls:", w, h+= 20);

  if (currentShape == GraphShape.SPHERE) {
    text("Key 'R': Rotate/Not", w, h+= 20);
  }
  text("Key 'S': Start/pause", w, h+= 20);
  text("Key 'L': Show/Not edges", w, h+= 20);
  text("Key 'H': Highlight/Not degree", w, h+= 20);

  h += 20;

  text("Key 'P': Plot remaining degree", w, h+= 20);
  text("Key 'O': Plot original degree", w, h+= 20);
  text("Key 'V': Plot average degree", w, h+= 20);
  text("Key 'A': Show all plots", w, h+= 20);

  h += 20;

  text("Key 'C': Color vertices", w, h+= 20);
  text("Key 'W': Color All/Single", w, h+= 20);
  text("Key 'E': Show Maximum Coverage", w, h+= 20);

  h += 20;

  text("Key 'X': Sceenshot", w, h+= 20);
}

void drawColoredRGGText() {

  int h = 0;
  textAlign(LEFT);
  fill(0, 255, 0);
  text("Rotate: " + (rot && allow3DRotate? "ON" : "OFF"), 15, h += 20);
  text("All vertex: " +(all ? "ON" : "OFF"), 15, h += 20);
  text("Show Max Coverage: " + (highlightMaxCoverageArea ? "ON" : "OFF"), 15, h+=20);
  
  text("Vertex count: " + VERTEX_COUNT, 15, h += 20);
  text("Color count: " + (maximum + 1), 15, h += 20);
  text("Terminal Clique: " + terminalClique, 15, h+=20);
  
  if (!all) {
    if (showColorAsBipartite) {
      text("Connected Vertex count: " + connectedVertexCount, 15, h += 20);
      text("Edge number: " + bipartiteEdgeNumber, 15, h += 20);
      text("Component number: " + component, 15, h += 20);
      text("Coverage: " + ((float)maxCoveredNodes / VERTEX_COUNT * 100) + "%", 15, h += 20);
      text("Face number: " + (bipartiteEdgeNumber - connectedVertexCount + 2 + component - 1), 15, h += 20);


      fill(cs[aPlace]);
      text("Color" + (aPlace + 1), 15, h += 20);

      fill(255);
      text("&", 66, h);

      fill(cs[bPlace]);
      text("Color " + (bPlace + 1), 78, h);
      
    } else {
      fill(cs[aPlace]);
      text("Color " + (aPlace + 1), 15, h += 20);
    }
  }
}

void setupFont() {
  PFont font = createFont("Arial", 16);
  textFont(font);
  textSize(16);
  textAlign(LEFT);
  stroke(strokeColor);
}
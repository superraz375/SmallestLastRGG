 //<>//
// Draw Initial RGG
// Perform Smallest Last Ordering
void drawInitialRGG() {

  drawStage1Text();

  textAlign(RIGHT);
  translate(width/2, height / 2);
  strokeWeight(1);

  handleMouseEvents();

  edgeCount = 0;
  wAvg = 0;


  drawPointsAndEdgesByDegree();

  minimum = 0;

  if (highlightMinMaxDegreeNodes) {
    showEdges = false;
    markMinDegreeNodes();
    markMaxDegreeNodes();
    stroke(strokeColor);
  }
  
  if(!savedDegreeDistribution) {
   saveDegreeDistribution();
   savedDegreeDistribution = true;
  }

  // Do the next SMALLEST LAST ORDERING removal step
  if (isProcessing) {
    performSmallestLastOrdering();
  }
}

boolean b = false;

void drawPointsAndEdgesByDegree() {
  for (int i = 0; i <= maximum; i++) {
    if (degreeList[i].isEmpty()) {
      continue;
    } else {

      int num = degreeList[i].size();
      wAvg += num * i;

      for (int j = 0; j < num; j++) {
        Point pointA = degreeList[i].get(j);

        strokeWeight(nodeSize);
        point(pointA, scaleFactor);
        //text(pointA.key, pointA.x * scaleFactor, pointA.y * scaleFactor);

        strokeWeight(edgeWidth);
        for (int k = 0; k < i; k++) {
          Point pointB = pointA.list.get(k);
          if (pointA.key < pointB.key) {
            edgeCount++;

            if (showEdges) {
              line(pointA, pointB, scaleFactor);
            }
          }
        }
      }
    }
  }
}

void markMinDegreeNodes() {
  // Calculate minimum degree index
  while (minimum <= maximum && degreeList[minimum].isEmpty()) {
    minimum++;
  }

  // Mark all minimum degree nodes
  for (int j = 0; j < degreeList[minimum].size(); j++) {
    Point pointA = degreeList[minimum].get(j);
    stroke(0, 255, 0);
    strokeWeight(nodeSize);
    point(pointA, scaleFactor);
    strokeWeight(edgeWidth);
    for (int k = 0; k < minimum; k++) {
      Point pointB = pointA.list.get(k);
      if (isHighlightEdges) {
        line(pointA, pointB, scaleFactor);
      }
    }
  }
  // Count number of min-degree nodes
  minAmount = degreeList[minimum].size();
}

void markMaxDegreeNodes() {
  // Calculate max-degree nodes
  if (maximum >= 0) {
    for (int j = 0; j < degreeList[maximum].size(); j++) {
      Point pointA = degreeList[maximum].get(j);
      stroke(255, 0, 0);
      strokeWeight(nodeSize);
      point(pointA, scaleFactor);
      strokeWeight(edgeWidth);
      for (int k = 0; k < maximum; k++) {
        Point pointB = pointA.list.get(k);
        if (isHighlightEdges) {
          line(pointA, pointB, scaleFactor);
        }
      }
      maxAmount = degreeList[maximum].size();
    }
  }
}

void performSmallestLastOrdering() {
  int degDif = 0;
  for (int count = 0; count < PROCESSING_INTERVAL; count++) {
    minimum = 0;

    // Re-adjust the minimum degree index
    while (minimum <= maximum && degreeList[minimum].isEmpty()) {
      minimum++;
    }
    
    
    if(minimum > maxMinDegree) {
     maxMinDegree = minimum; 
    }


    // Remove the node with the smallest degree [SMALLEST LAST]
    if (rIndex >= 0) {
      Point minDegree = degreeList[minimum].get(0);
      records[rIndex] = new Record(minDegree, minimum);
      wAvg -= degDif;
      records[rIndex].avgDegree = wAvg / (rIndex + 1);
      degDif = 2 * minimum;
      rIndex--;
      degreeList[minimum].remove(0);
      for (int i = 0; i < minimum; i++) {
        int index = minDegree.list.get(i).key;
        int degree = graph[index].list.size();

        graph[index].list.remove(binarySearch(graph[index].list, minDegree.key, 0, degree - 1));
        degreeList[degree].remove(graph[index]);
        degreeList[degree - 1].add(graph[index]);
      }
    }
    
    //captureScreenshot();

    // Re-adjust the maximum degree index
    while (maximum >= 0 && degreeList[maximum].isEmpty()) {
      maximum--;
    }
  }
}
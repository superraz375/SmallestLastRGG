void colorNodes() {
    maximum = 0;
    for (int i = 0; i < VERTEX_COUNT; i++) {
      int n = 0;
      for (int j = 0; j < records[i].degree; j++) {
        if (cs[n] == records[i].point.list.get(j).c) {
          n++;
          j = -1;
        }
      }
      records[i].point.c = cs[n];
      if (n > maximum) {
        maximum = n;
      }
    }  
}

void drawColoredRGG() {
  
  drawColoredRGGText();
  textAlign(RIGHT);
  translate(width / 2, height / 2);
  mouseControl();
  
  if (!finishedColoring) {
    colorNodes();
    finishedColoring = true;
  }

  strokeWeight(4);

  if (!showColorAsBipartite) {
    if (needsToUpdateColorNodes) {
      
      aList.clear();
      if (!all) {
        for (int i = 0; i <= maximum; i++) {
          if (i == aPlace) {
            aIndex = i;
            break;
          }
        }
      }
      for (int i = 0; i < VERTEX_COUNT; i++) {
        if (all || cs[aIndex] == records[i].point.c) {
          stroke(records[i].point.c);
          point(records[i].point, scaleFactor);
          aList.add(records[i]);
        }
      }
      needsToUpdateColorNodes = false;
    } else {
      for (int i = 0; i < aList.size(); i++) {
        stroke(aList.get(i).point.c);
        point(aList.get(i).point, scaleFactor);
      }
    }
    stroke(strokeColor);
  } else {
    // SHOWING BIPARTITENESS
    if (tBColor) {
      aList.clear();
      bList.clear();
      int i;
      for (i = 0; i < maximum; i++) {
        if (i == aPlace || i == bPlace) {
          aIndex = i;
          break;
        }
      }
      for (int j = i + 1; j <= maximum; j++) {
        if (j == aPlace || j == bPlace) {
          bIndex = j;
          break;
        }
      }
      for (int j = 0; j < VERTEX_COUNT; j++) {
        if (cs[aIndex] == records[j].point.c) {
          stroke(records[j].point.c);
          point(records[j].point, scaleFactor);
          aList.add(records[j]);
        } else if (cs[bIndex] == records[j].point.c) {
          stroke(records[j].point.c);
          point(records[j].point, scaleFactor);
          bList.add(records[j]);
        }
      }
      for (int j = 0; j < aList.size(); j++) {
        aList.get(j).point.list.clear();
        aList.get(j).point.visited = false;
      }
      for (int j = 0; j < bList.size(); j++) {
        bList.get(j).point.list.clear();
        bList.get(j).point.visited = false;
      }
      bipartiteEdgeNumber = 0;
      conList.clear();
      strokeWeight(1);
      stroke(strokeColor);
      for (int j = 0; j < aList.size(); j++) {
        Point pointA = aList.get(j).point;
        int tempE = bipartiteEdgeNumber;
        for (int k = 0; k < bList.size(); k++) {
          Point pointB = bList.get(k).point;
          if (dist(pointA, pointB) < r * RGG_THRESHOLD) {
            bipartiteEdgeNumber++;
            pointA.list.add(pointB);
            pointB.list.add(pointA);
            if (isHighlightEdges) {
              line(pointA, pointB, scaleFactor);
            }
          }
        }
        if (tempE < bipartiteEdgeNumber) {
          conList.add(pointA);
        }
      }
      calNumber(conList);
      tBColor = false;
    } else {
      for (int i = 0; i < aList.size(); i++) {
        stroke(aList.get(i).point.c);
        point(aList.get(i).point, scaleFactor);
      }
      for (int i = 0; i < bList.size(); i++) {
        stroke(bList.get(i).point.c);
        point(bList.get(i).point, scaleFactor);
      }
      strokeWeight(1);
      stroke(strokeColor);
      for (int i = 0; i < conList.size(); i++) {
        Point PointA = conList.get(i);
        for (int j = 0; j < PointA.list.size(); j++) {
          Point PointB = PointA.list.get(j);
          
          if (isHighlightEdges) {
            line(PointA, PointB, scaleFactor);
          }
        }
      }
    }
  }
}
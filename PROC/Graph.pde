void generateRGG() {

  updateRggThreshold();

  switch(currentShape) {
  case SPHERE:
    generateSphereRGG();
    break;
  case DISK:
    generateDiskRGG();
    break;
  case SQUARE:
    generateSquareRGG();
    break;
  }
}
void generateSphereRGG() {
  allow3DRotate = true;
  createSpherePoints();
  connectRGGNodes();
  calculateDegrees();
}


void generateDiskRGG() {
  allow3DRotate = false;
  createDiskPoints();
  connectRGGNodes();
  calculateDegrees();
}

void generateSquareRGG() {
  allow3DRotate = false;
  createSquarePoints();
  connectRGGNodes();
  calculateDegrees();
}



void sortPoints() {
 Arrays.sort(graph); //<>//
 for (int i = 0; i < VERTEX_COUNT; i++) {
   graph[i].key = i;
 }
}

void createSquarePoints() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    float x = random(-1, 1) * r;
    float y = random(-1, 1) * r;
    Point p = new Point(i, x, y, 0);

    graph[i] = p;
    degreeList[i] = new ArrayList();
  }
  sortPoints();
}

void createDiskPoints() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    Point p = randomDiskPoint(r, i);

    graph[i] = p;
    degreeList[i] = new ArrayList();
  }
  sortPoints();
}
// Generate random sphere points
void createSpherePoints() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    graph[i] = randomSpherePoint(r, i);
    degreeList[i] = new ArrayList();
  }
  sortPoints();
}

// Connect RGG nodes within the threshold
void connectRGGNodes() {

  connectLinearScan();
  //connectBruteForce(); 
}

void connectLinearScan() {
  
  for (int i = 0; i < VERTEX_COUNT; i++) {
    for (int j = i + 1; j < VERTEX_COUNT; j++) {
      
      if(abs(graph[j].x - graph[i].x) > RGG_THRESHOLD * r) {
       continue; 
      }
      
      if (dist(graph[i], graph[j]) < ADJUSTED_RGG_THRESHOLD_SQUARED) {
        graph[i].list.add(graph[j]);
        graph[j].list.add(graph[i]);
      }
    }
  }
}

void connectBruteForce() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    for (int j = i + 1; j < VERTEX_COUNT; j++) {
      if (dist(graph[i], graph[j]) < ADJUSTED_RGG_THRESHOLD_SQUARED) {
        graph[i].list.add(graph[j]);
        graph[j].list.add(graph[i]);
      }
    }
  }
}

// Calculate degrees for each node as well as the maximum degree found
void calculateDegrees() {

  int total = 0;

  for (int i = 0; i < VERTEX_COUNT; i++) {
    if (graph[i].list.size() > maximum) {
      maximum = graph[i].list.size();
    }
    degreeList[graph[i].list.size()].add(graph[i]);
    graph[i].degree = graph[i].list.size();

    total += graph[i].degree;
  }

  graphAverageDegree = (float)total / VERTEX_COUNT;
}

void draw() {

  pushMatrix();
  drawControlText();

  if (currentStatus == GraphStage.INITIAL_GRAPH && rIndex >= 0) {    
    drawOutline();
    drawInitialRGG();
  } else if (currentStatus == GraphStage.PLOT) {
    drawPlot();
  } else if (currentStatus == GraphStage.COLOR_GRAPH && finishedPlotting) {
    drawOutline();
    drawColoredRGG();
  }

  if (capture) {
    captureScreenshot();
  }

  popMatrix();
}

void captureScreenshot() {


  saveFrame(currentShape + "-######.png");
  capture = false;
}

Point randomSpherePoint(float radius, int key) {

  float theta = 2 * PI * random(0.0, 1.0);
  float phi = acos(2*random(0.0, 1.0) - 1.0);
  float x = cos(theta) * sin(phi);
  float y = sin(theta) * sin(phi);
  float z = cos(phi);

  x *= radius;
  y *= radius;
  z *= radius;

  return new Point(key, x, y, z);
}

Point randomDiskPoint(float radius, int key) {

  radius *= sqrt(random(0.0, 1.0));

  float theta = 2 * PI * random(0.0, 1.0);
  float x = cos(theta) * radius;
  float y = sin(theta) * radius;

  return new Point(key, x, y, 0);
}

int binarySearch(ArrayList < Point > list, int key, int imin, int imax) {
  while (imax >= imin) {
    int imid = (imin + imax) / 2;
    if (list.get(imid).key < key) {
      imin = imid + 1;
    } else if (list.get(imid).key > key) {
      imax = imid - 1;
    } else {
      return imid;
    }
  }
  return -1;
}

void dfs(Point point) {
  point.visited = true;
  connectedVertexCount++;
  for (int i = 0; i < point.list.size(); i++) {
    if (!point.list.get(i).visited) {
      dfs(point.list.get(i));
    }
  }
}

void calculateComponents(ArrayList < Point > list) {
  connectedVertexCount = 0;
  component = 0;
  boolean end = false;
  while (!end) {
    end = true;
    for (int i = 0; i < list.size(); i++) {
      if (!list.get(i).visited) {
        component++;
        end = false;
        dfs(list.get(i));
        break;
      }
    }
  }
}

void calculateRggThresholdByAverageDegree() {


  switch(currentShape) {
  case SPHERE:
    {
      float area = 4*(AVERAGE_DEGREE+1);
      area /= VERTEX_COUNT;
      RGG_THRESHOLD = (float) Math.sqrt(area);
      break;
    }
  case DISK:
    {
      float area = AVERAGE_DEGREE+1;
      area /= VERTEX_COUNT;
      RGG_THRESHOLD = (float) Math.sqrt(area);
      break;
    }
  case SQUARE:
    RGG_THRESHOLD = (float) Math.sqrt(4*(AVERAGE_DEGREE+1)/(VERTEX_COUNT*Math.PI));
    break;
  }
}

// Draw an outline for each graph
void drawOutline() {

  strokeWeight(5);

  switch(currentShape) {
  case DISK:
    ellipseMode(RADIUS);
    fill(0);
    ellipse(width/2, height / 2, r*scaleFactor+5, r*scaleFactor+5);
    break;
  case SQUARE:
    rectMode(RADIUS);
    fill(0);
    rect(width/2, height / 2, r*scaleFactor+5, r*scaleFactor+5);
    break;
  case SPHERE:
    break;
  }

  strokeWeight(1);
}

void updateRggThreshold() {
  if (!USE_RGG_THRESHOLD) {
    calculateRggThresholdByAverageDegree();
  }
  ADJUSTED_RGG_THRESHOLD_SQUARED = sq(RGG_THRESHOLD * r);
}

void point(Point p, float scaleF) {
  point(scaleF*p.x, scaleF*p.y, scaleF*p.z);
}

void line(Point p1, Point p2, float scaleF) {
  line(scaleF*p1.x, scaleF*p1.y, scaleF*p1.z, 
    scaleF*p2.x, scaleF*p2.y, scaleF*p2.z
    );
}

float dist(Point p1, Point p2) {
  return sq(p2.x - p1.x) + sq(p2.y - p1.y) + sq(p2.z - p1.z);
}
final int VERTEX_COUNT = 3000;
final float RGG_THRESHOLD = 0.125;
final int PROCESSING_INTERVAL = 10;

final float MIN_SCALE = 0.20;
final float MAX_SCALE = 5.0;
final float ROTATION_DELTA = 0.002;

final int SPHERE = 1;
final int DISK = 2;
final int SQUARE = 3;

int currentShape = SPHERE;
int connectedVertexCount, edgeCount, bipartiteEdgeNumber;
int component, maximum = 0, minimum = 0, minAmount, maxAmount;
int pMax = 0, oMax = 0; // for plotting
int rIndex = VERTEX_COUNT - 1;
int aIndex = -1;
int bIndex = -1;
int aPlace = 0, bPlace = 0;

int status = 0, pStatus = 0;
int cCount = 1;
float r;
float scaleFactor;
float avg = 0, avgO = 0, avgW = 0, wAvg = 0, hd, rotX, rotY = 0, wMax = 0;

boolean allow3DRotate = false;
boolean all = true, finishedPlotting = false, finishedColoring = false, turnOP = true, turnWP = true, isProcessing = false, showEdges = false, highlightMinMaxDegreeNodes = false;
boolean capture = false, isHighlightEdges = true, rot = true, showColorAsBipartite = false, needsToUpdateColorNodes = false, tBColor = false;
color strokeColor = color(250, 250, 0);

Point[] graph = new Point[VERTEX_COUNT];
Record[] records = new Record[VERTEX_COUNT];
color[] cs;
ArrayList < Point > [] degreeList = new ArrayList[VERTEX_COUNT];
ArrayList < Record > aList = new ArrayList();
ArrayList < Record > bList = new ArrayList();
ArrayList < Point > conList = new ArrayList();

void clearData() {

  maximum = 0;
  minimum = 0;
  minAmount = 0;
  maxAmount = 0;
  pMax = 0;
  oMax = 0;
  rIndex = VERTEX_COUNT - 1;
  aIndex = -1;
  bIndex = -1;
  status = 0;
  pStatus = 0;
  aPlace = 0;
  bPlace = 0;
  cCount = 1;
  avg = 0;
  avgO = 0;
  avgW = 0;
  wAvg = 0;
  wMax = 0;
  isProcessing = false;
  showColorAsBipartite = false;
  needsToUpdateColorNodes = false;
  tBColor = false;
  finishedColoring = false;
  finishedPlotting = false;
  strokeColor = color(250, 250, 0);
  all = true;

  graph = new Point[VERTEX_COUNT];
  records = new Record[VERTEX_COUNT];
  degreeList = new ArrayList[VERTEX_COUNT];
  aList = new ArrayList();
  bList = new ArrayList();
  conList = new ArrayList();
}
// Setup the program for running
void setup() {

  fullScreen(P3D);
  //size(600, 600, P3D);
  
  pixelDensity(2);
  r = (height - 120) / 2;
  scaleFactor = 1;
  frameRate(60);
  setupFont();
  generateRGG();
}

void generateRGG() {
  if (currentShape == SPHERE) {
    generateSphereRGG();
  } else if (currentShape == DISK) {
    generateSquareRGG();
  } else if (currentShape == SQUARE) {
    generateDiskRGG();
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

void createSquarePoints() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    float x = random(-1, 1) * r;
    float y = random(-1, 1) * r;
    Point p = new Point(i, x, y, 0);

    graph[i] = p;
    degreeList[i] = new ArrayList();
  }
}

void createDiskPoints() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    Point p = randomDiskPoint(r, i);

    graph[i] = p;
    degreeList[i] = new ArrayList();
  }
}
// Generate random sphere points
void createSpherePoints() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    graph[i] = randomSpherePoint(r, i);
    degreeList[i] = new ArrayList();
  }
}

// Connect RGG nodes within the threshold
void connectRGGNodes() {

  // TODO: See if there is a more efficient algorithm to scan for RGG links.
  // E.G. Scanning method from Unit Square.

  for (int i = 0; i < VERTEX_COUNT; i++) {
    for (int j = i + 1; j < VERTEX_COUNT; j++) {
      if (dist(graph[i], graph[j]) < r * RGG_THRESHOLD) {
        graph[i].list.add(graph[j]);
        graph[j].list.add(graph[i]);
      }
    }
  }
}

// Calculate degrees for each node as well as the maximum degree found
void calculateDegrees() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    if (graph[i].list.size() > maximum) {
      maximum = graph[i].list.size();
    }
    degreeList[graph[i].list.size()].add(graph[i]);
    graph[i].degree = graph[i].list.size();
  }
}

void draw() {

  drawControlText();

  if (rIndex >= 0) {
    drawInitialRGG();
  } else if (status == 1) {
    drawPlot();
  } else if (status == 2 && finishedPlotting) {
    drawColoredRGG();
  }

  if (capture) {
    saveFrame("sphere-######.png");
    capture = false;
  }
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

void calNumber(ArrayList < Point > list) {
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

void point(Point p, float scaleF) {
  point(scaleF*p.x, scaleF*p.y, scaleF*p.z);
}

void line(Point p1, Point p2, float scaleF) {
  line(scaleF*p1.x, scaleF*p1.y, scaleF*p1.z, 
    scaleF*p2.x, scaleF*p2.y, scaleF*p2.z
    );
}

float dist(Point p1, Point p2) {
  return dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
}
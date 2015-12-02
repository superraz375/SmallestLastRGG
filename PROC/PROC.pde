import controlP5.*;

int VERTEX_COUNT = 4000;
float RGG_THRESHOLD = 0.125;
int AVERAGE_DEGREE = 30;
int PROCESSING_INTERVAL = 10;
boolean USE_RGG_THRESHOLD = true;

final float MIN_SCALE = 0.20;
final float MAX_SCALE = 5.0;
final float ROTATION_DELTA = 0.002;

final int SPHERE = 1;
final int DISK = 2;
final int SQUARE = 3;

int currentShape = DISK;
int connectedVertexCount, edgeCount, bipartiteEdgeNumber;
int component, maximum = 0, minimum = 0, minAmount, maxAmount;
int pMax = 0, oMax = 0; // for plotting
int rIndex = VERTEX_COUNT - 1;
int aIndex = -1;
int bIndex = -1;
int aPlace = 0, bPlace = 0;
int status = 0, pStatus = 0;
int cCount = 1;

ControlP5 cp5;
float edgeWidth = 1.0;
float nodeSize = 4.0;

float r;
float scaleFactor;
float ADJUSTED_RGG_THRESHOLD_SQUARED;
float avg = 0, avgO = 0, avgW = 0, wAvg = 0, hd, rotX, rotY = 0, wMax = 0;
float graphAverageDegree = 0;

boolean allow3DRotate = false;
boolean all = true, finishedPlotting = false, finishedColoring = false, turnOP = true;
boolean turnWP = true, isProcessing = false, showEdges = false, highlightMinMaxDegreeNodes = false;
boolean capture = false, isHighlightEdges = true, rot = true;
boolean showColorAsBipartite = false, needsToUpdateColorNodes = false, needsToUpdateBipartiteColorNodes = false;

color strokeColor = color(250, 250, 0);

Point[] graph = new Point[VERTEX_COUNT];
Record[] records = new Record[VERTEX_COUNT];
color[] cs;
ArrayList < Point > [] degreeList = new ArrayList[VERTEX_COUNT];
ArrayList < Record > aList = new ArrayList();
ArrayList < Record > bList = new ArrayList();
ArrayList < Point > conList = new ArrayList();

 color[] COLORS = new color[] {
        #FFFF00, #1CE6FF, #FF34FF, #FF4A46, #008941, #006FA6, #A30059, #92896B,
        #FFDBE5, #7A4900, #0000A6, #63FFAC, #B79762, #004D43, #8FB0FF, #997D87,
        #5A0007, #809693, #FEFFE6, #1B4400, #4FC601, #3B5DFF, #4A3B53, #FF2F80,
        #61615A, #BA0900, #6B7900, #00C2A0, #FFAA92, #FF90C9, #B903AA, #D16100,
        #DDEFFF, #000035, #7B4F4B, #A1C299, #300018, #0AA6D8, #013349, #00846F,
        #372101, #FFB500, #C2FFED, #A079BF, #CC0744, #C0B9B2, #C2FF99, #001E09,
        #00489C, #6F0062, #0CBD66, #EEC3FF, #456D75, #B77B68, #7A87A1, #788D66,
        #885578, #FAD09F, #FF8A9A, #D157A0, #BEC459, #456648, #0086ED, #886F4C,
        
        #34362D, #B4A8BD, #00A6AA, #452C2C, #636375, #A3C8C9, #FF913F, #938A81,
        #575329, #00FECF, #B05B6F, #8CD0FF, #3B9700, #04F757, #C8A1A1, #1E6E00,
        #7900D7, #A77500, #6367A9, #A05837, #6B002C, #772600, #D790FF, #9B9700,
        #549E79, #FFF69F, #201625, #72418F, #BC23FF, #99ADC0, #3A2465, #922329,
        #5B4534, #FDE8DC, #404E55, #0089A3, #CB7E98, #A4E804, #324E72, #6A3A4C,
        #83AB58, #001C1E, #D1F7CE, #004B28, #C8D0F6, #A3A489, #806C66, #222800,
        #BF5650, #E83000, #66796D, #DA007C, #FF1A59, #8ADBB4, #1E0200, #5B4E51,
        #C895C5, #320033, #FF6832, #66E1D3, #CFCDAC, #D0AC94, #7ED379, #012C58,
        
        #7A7BFF, #D68E01, #353339, #78AFA1, #FEB2C6, #75797C, #837393, #943A4D,
        #B5F4FF, #D2DCD5, #9556BD, #6A714A, #001325, #02525F, #0AA3F7, #E98176,
        #DBD5DD, #5EBCD1, #3D4F44, #7E6405, #02684E, #962B75, #8D8546, #9695C5,
        #E773CE, #D86A78, #3E89BE, #CA834E, #518A87, #5B113C, #55813B, #E704C4,
        #00005F, #A97399, #4B8160, #59738A, #FF5DA7, #F7C9BF, #643127, #513A01,
        #6B94AA, #51A058, #A45B02, #1D1702, #E20027, #E7AB63, #4C6001, #9C6966,
        #64547B, #97979E, #006A66, #391406, #F4D749, #0045D2, #006C31, #DDB6D0,
        #7C6571, #9FB2A4, #00D891, #15A08A, #BC65E9, #FFFFFE, #C6DC99, #203B3C,

        #671190, #6B3A64, #F5E1FF, #FFA0F2, #CCAA35, #374527, #8BB400, #797868,
        #C6005A, #3B000A, #C86240, #29607C, #402334, #7D5A44, #CCB87C, #B88183,
        #AA5199, #B5D6C3, #A38469, #9F94F0, #A74571, #B894A6, #71BB8C, #00B433,
        #789EC9, #6D80BA, #953F00, #5EFF03, #E4FFFC, #1BE177, #BCB1E5, #76912F,
        #003109, #0060CD, #D20096, #895563, #29201D, #5B3213, #A76F42, #89412E,
        #1A3A2A, #494B5A, #A88C85, #F4ABAA, #A3F3AB, #00C6C8, #EA8B66, #958A9F,
        #BDC9D2, #9FA064, #BE4700, #658188, #83A485, #453C23, #47675D, #3A3F00,
        #061203, #DFFB71, #868E7E, #98D058, #6C8F7D, #D7BFC2, #3C3E6E, #D83D66,
 };

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
  needsToUpdateBipartiteColorNodes = false;
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

  //fullScreen(P3D);
  size(1500, 1000, P3D);
  
  pixelDensity(2);
  r = (height - 120) / 2;
  scaleFactor = 1;
  ADJUSTED_RGG_THRESHOLD_SQUARED = sq(RGG_THRESHOLD * r);
  frameRate(60);
  setupFont();
  setupUI();
  
  generateRGG();
}

void generateRGG() {
  if (currentShape == SPHERE) {
    generateSphereRGG();
  } else if (currentShape == SQUARE) {
    generateSquareRGG();
  } else if (currentShape == DISK) {
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
  
    graphAverageDegree = total / VERTEX_COUNT;;
}

void draw() {

  pushMatrix();
  drawControlText();

  if (rIndex >= 0) {
    
    drawOutline();
    drawInitialRGG();
  } else if (status == 1) {
    drawPlot();
  } else if (status == 2 && finishedPlotting) {
    drawOutline();
    drawColoredRGG();
  }

  if (capture) {
    saveFrame("sphere-######.png");
    capture = false;
  }
  popMatrix();
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
  return sq(p2.x - p1.x) + sq(p2.y - p1.y) + sq(p2.z - p1.z);
}
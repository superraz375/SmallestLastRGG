import controlP5.*;
import java.util.Arrays;

int VERTEX_COUNT = 4000;
float RGG_THRESHOLD = .0825;
int AVERAGE_DEGREE = 30;
int PROCESSING_INTERVAL = 10;
boolean USE_RGG_THRESHOLD = true;

final float MIN_SCALE = 0.20;
final float MAX_SCALE = 5.0;
final float ROTATION_DELTA = 0.002;
final int FRAME_RATE = 60;

GraphShape currentShape = GraphShape.DISK;
GraphStage currentStatus = GraphStage.INITIAL_GRAPH;
PlotType currentPlotType = PlotType.NONE;

// PLOTTING
int pMax = 0, oMax = 0;

// COLORING
int connectedVertexCount, edgeCount, bipartiteEdgeNumber;
int aIndex = -1;
int bIndex = -1;
int aPlace = 0, bPlace = 0;
boolean showColorAsBipartite = false;
boolean needsToUpdateColorNodes = false, needsToUpdateBipartiteColorNodes = false;
int maxCoveredNodes;
boolean highlightMaxCoverageArea = false;
Point maxComponentPoint;
int coverageOpacity = 30;
int terminalClique = 0;
boolean savedDegreeDistribution = false;
int maxMinDegree = 0;

int component, maximum = 0, minimum = 0, minAmount, maxAmount;
int rIndex = VERTEX_COUNT - 1;
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
boolean capture = false, isHighlightEdges = true, rot = true;;


color strokeColor = color(250, 250, 0);

Point[] graph = new Point[VERTEX_COUNT];
Record[] records = new Record[VERTEX_COUNT];
color[] cs;
int[] colorCount;
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
  currentStatus = GraphStage.INITIAL_GRAPH;
  currentPlotType = PlotType.NONE;
  aPlace = 0;
  bPlace = 0;
  maxCoveredNodes = 0;
  cCount = 1;
  avg = 0;
  avgO = 0;
  avgW = 0;
  wAvg = 0;
  wMax = 0;
  maxMinDegree = 0;
  terminalClique = 0;


  isProcessing = false;
  showColorAsBipartite = false;
  needsToUpdateColorNodes = false;
  needsToUpdateBipartiteColorNodes = false;
  highlightMaxCoverageArea = false;
  finishedColoring = false;
  finishedPlotting = false;
  savedDegreeDistribution = false;
  strokeColor = color(250, 250, 0);
  all = true;

  graph = new Point[VERTEX_COUNT];
  records = new Record[VERTEX_COUNT];
  degreeList = new ArrayList[VERTEX_COUNT];
  aList = new ArrayList();
  bList = new ArrayList();
  conList = new ArrayList();
  
  println(graph.length);
  println(records.length);
}
// Setup the program for running
void setup() {

  fullScreen(P3D);
  //size(1200, 800, P3D);

  pixelDensity(2);
  r = (height - 120) / 2;
  scaleFactor = 1;
  ADJUSTED_RGG_THRESHOLD_SQUARED = sq(RGG_THRESHOLD * r);
  frameRate(FRAME_RATE);
  setupFont();
  setupUI();
  clearData();

  generateRGG();
}
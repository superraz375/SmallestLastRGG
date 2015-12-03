int hp;
int ph;
float wd;
float ht;
float p4;
float p2;

void drawPlot() {
  hp = height - 30;
  ph = hp + 5;
  wd = (width - 60.0) / VERTEX_COUNT;
  ht = height - 10;
  p2 = (30 + width /2) / 2;
  p4 = (width - 30 + width/2) / 2;

  if (currentPlotType == PlotType.ORIGINAL_DEGREE || currentPlotType == PlotType.ALL) {
    plotOriginalDegree();
  }

  if (currentPlotType == PlotType.REMAINING_DEGREE || currentPlotType == PlotType.ALL) {  
    plotRemainingDegree();
  }

  text("RRR" + round(avg), 24, ph - avg * hd);

  if (currentPlotType == PlotType.AVERAGE_DEGREE || currentPlotType == PlotType.ALL) {
    plotAverageDegree();
  }

  drawPlotBorder();
}

void drawPlotBorder() {
  text(round(avgW), 24, ph - avgW * hd);
  stroke(strokeColor);
  strokeWeight(2);
  line(30, 0, 30, ph);
  line(25, hp, width, hp);
  line(width - 30, ph, width - 30, hp);
  line(p2, ph, p2, hp);
  line(width/2, ph, width/2, hp);
  line(p4, ph, p4, hp);
  fill(strokeColor);
  text(records[0].point.key, 45, ht);
  if (VERTEX_COUNT > 1) {
    text(records[VERTEX_COUNT - 1].point.key, width - 15, ht);
  }

  if (VERTEX_COUNT > 2) {
    text(records[VERTEX_COUNT / 2].point.key, width/2 + 15, ht);
  }

  if (VERTEX_COUNT > 4) {
    text(records[VERTEX_COUNT * 3 / 4].point.key, p2 + 15, ht);
  }

  text(records[VERTEX_COUNT / 4].point.key, p4 + 15, ht);

  text(0, 24, ph);
}

void plotOriginalDegree() {
  
  if (turnOP) {
    for (int i = 0; i < VERTEX_COUNT; i++) {
      if (records[i].point.degree > oMax) {
        oMax = records[i].point.degree;
      }

      avgO += records[i].point.degree;
      hd = (height - 60.0) / oMax;
      avgO /= VERTEX_COUNT;
    }
  }
 
  turnOP = false;
  stroke(255, 0, 255);
  strokeWeight(2);
  line(25, hp - avgO * hd, 30, hp - avgO * hd);
  line(25, hp - oMax * hd, 30, hp - oMax * hd);
  strokeWeight(1);
  
  for (int i = 0; i < VERTEX_COUNT - 1; i++) {
    line(30 + i * wd, hp - hd * records[i].point.degree, 30 + (i + 1) * wd, hp - hd * records[i + 1].point.degree);
  }
  
  fill(255, 0, 255);
  text(oMax, 24, 35);
  text(round(avgO), 24, ph - avgO * hd);
}

void plotRemainingDegree() {
 
  if (!turnOP) {
    if (!finishedPlotting) {
      for (int i = 0; i < VERTEX_COUNT; i++) {
        if (records[i].degree > pMax) {
          pMax = records[i].degree;
        }
        avg += records[i].degree;
      }
      avg /= VERTEX_COUNT;

      generateColors(pMax + 1);

      for (int i = 0; i <= pMax; i++) {
        int tempI = round(random(pMax + 0.1));
        color temp = cs[tempI];
        cs[tempI] = cs[i];
        cs[i] = temp;
      }
      finishedPlotting = true;
    }

    stroke(0, 255, 0);
    strokeWeight(2);
    line(25, hp - avg * hd, 30, hp - avg * hd);
    line(25, hp - pMax * hd, 30, hp - pMax * hd);
    strokeWeight(1);
    
    for (int i = 0; i < VERTEX_COUNT - 1; i++) {
      line(30 + i * wd, hp - hd * records[i].degree, 30 + (i + 1) * wd, hp - hd * records[i + 1].degree);
    }
    
    fill(0, 255, 0);
    text(pMax, 24, ph - pMax * hd);
  }
}

void plotAverageDegree() {
 
  if (turnWP) {
    for (int i = 0; i < VERTEX_COUNT; i++) {
     
      if (records[i].avgDegree > wMax) {
        wMax = records[i].avgDegree;
      }

      avgW += records[i].degree;
      avgW /= VERTEX_COUNT;
      turnWP = false;
    }
  }
  
  stroke(0, 0, 255);
  strokeWeight(2);
  line(25, hp - avgW * hd, 30, hp - avgW * hd);
  line(25, hp - wMax * hd, 30, hp - wMax * hd);
  strokeWeight(3);
 
  for (int i = 0; i < VERTEX_COUNT - 1; i++) {
    line(30 + i * wd, hp - hd * records[i].avgDegree, 30 + (i + 1) * wd, hp - hd * records[i + 1].avgDegree);
  }
  
  fill(0, 0, 255);
  text(round(wMax), 24, ph - wMax * hd);
}

void generateColors(int total) {
  cs = new color[total];

  for (int i = 0; i < total; i++) {
    cs[i] = COLORS[i % COLORS.length];
  }
}
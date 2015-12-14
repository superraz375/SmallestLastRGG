void saveDegreeTable() {
  Table table = new Table();

  table.addColumn("ID");
  table.addColumn("Remaining Degree");
  table.addColumn("Original Degree");


  int cliqueCounter = 0;
  terminalClique = 0;

  for (int i = 0; i < VERTEX_COUNT - 1; i++) {
    TableRow newRow = table.addRow();
    newRow.setInt("ID", i);
    newRow.setInt("Remaining Degree", records[i].degree);
    newRow.setInt("Original Degree", records[i].point.degree);


    int deg = records[i].degree;

    if (deg == cliqueCounter) {
      cliqueCounter++;
    } else {
      if (cliqueCounter > terminalClique) {
        terminalClique = cliqueCounter;
      }
      cliqueCounter = 0;
    }
  }

  saveTable(table, generateFileName("DegreePlot"));
}


String generateFileName(String title) {
  return "data/" + currentShape + "_" + VERTEX_COUNT + "_" + RGG_THRESHOLD + "_" + title + ".csv";
}


void saveDegreeDistribution() {
  
  Table table = new Table();

  table.addColumn("Degree");
  table.addColumn("Count");

  for(int i= 0; i < maximum; i++) {
    int size = degreeList[i].size();
    TableRow newRow = table.addRow();
    newRow.setInt("Degree", i);
    newRow.setInt("Count", size);
  }
  
  saveTable(table, generateFileName("DegreeDistribution"));
}

void saveColorDistribution() {
  
  //TODO
  Table table = new Table();

  table.addColumn("Color");
  table.addColumn("Count");

  for(int i= 0; i < cs.length; i++) {
    TableRow newRow = table.addRow();
    newRow.setInt("Color", i);
    newRow.setInt("Count", colorCount[i]);
  }
  
  saveTable(table, generateFileName("ColorDistribution"));
}
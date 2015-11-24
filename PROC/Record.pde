class Record {
  Point point;
  int degree;
  float avgDegree;
  Record(Point point, int degree) {
    this.point = point;
    this.degree = degree;
    avgDegree = 0;
  }
}
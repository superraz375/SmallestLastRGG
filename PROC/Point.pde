class Point {
  float x, y, z;
  int key, degree;
  boolean visited;
  color c;
  ArrayList < Point > list;

  Point(int key, float x, float y, float z) {
    this.key = key;
    this.x = x;
    this.y = y;
    this.z = z;
    c = color(0);
    list = new ArrayList();
    degree = 0;
    visited = false;
  }
}
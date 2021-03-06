class Point implements Comparable {
  float x, y, z;
  int key, degree;
  boolean visited;
  boolean covered;
  color c;
  ArrayList < Point > list;
  ArrayList < Point > coverageList;

  Point(int key, float x, float y, float z) {
    this.key = key;
    this.x = x;
    this.y = y;
    this.z = z;
    c = color(0);
    list = new ArrayList();
    coverageList = new ArrayList();
    degree = 0;
    visited = false;
    covered = false;
  }
  
  int compareTo(Object o2) {
    if(o2 == null) { 
     return 1; 
    }
    
    Float x1 = x;
    Float x2 = ((Point) o2).x;
    return x1.compareTo(x2);
  }
}
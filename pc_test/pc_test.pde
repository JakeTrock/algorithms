 Point [] p;
void setup(){
  size(400, 400);
  p = new Point[4];
  p[0] = new Point(200, 100);
  p[1] = new Point(200,200);
  p[2] = new Point(80,180);
  p[3] = new Point(50,100);
}
void draw(){
  background(255);
  quad(p[0].x, p[0].y, p[1].x, p[1].y, p[2].x, p[2].y, p[3].x, p[3].y);
  if(insidePolygon(mouseX, mouseY, p)) fill(0); else fill(255);
}
boolean insidePolygon(float x, float y, Point [] p){
  int i, j, c = 0;
  for (i = 0, j = p.length-1; i < p.length; j = i++) {
    if ((((p[i].y <= y) && (y < p[j].y)) ||
  ((p[j].y <= y) && (y < p[i].y))) &&
  (x < (p[j].x - p[i].x) * (y - p[i].y) / (p[j].y - p[i].y) + p[i].x))
  c = (c+1)%2;
  }
  return c==1;
}
static class Point{
  float x,y;
  Point(float x, float y){
    this.x = x;
    this.y = y;
  }
}

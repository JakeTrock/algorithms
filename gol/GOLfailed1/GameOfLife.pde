import java.util.stream.*;
import java.util.Arrays;

Game g;
int [] pattern;
boolean delRule=false;

void setup() {
  fullScreen();
  pattern = new int[width*height];
  for (int i = 0; i < height; i++) {
    pattern[(i*width)+width/2] = 1;
  }
  g = new Game(width, height);
  background(0);
  frameRate(120);

  int[] ruleset = {int(random(0, 1.4)), int(random(0, 1.4)), int(random(0, 1.4)), int(random(0, 1.4)), int(random(0, 1.4)), int(random(0, 1.4)), int(random(0, 1.4)), int(random(0, 1.4))}; 
  for (int generation=0; generation<height; generation++) {
    int[] newcells = new int[width];
    for (int i = 1; i < width-1; i++) {
      int left = pattern[i-1];
      int middle = pattern[i];
      int right = pattern[i+1];
      String binaryNum = "" + str(left) + str(middle) + str(right);
      int index = Integer.parseInt(binaryNum, 2);
      newcells[i] = ruleset[index];
    }
    for (int i = 0; i<newcells.length; i++) {
      pattern[(generation*width)+i] = newcells[i];
    }
  }
}

void draw() {
  g.nextGeneration();
  g.display();
  if (keyPressed)delRule=!delRule;
  //if(mousePressed)mouseY*width + mouseX
}


class Cell {
  int state, age;  // 0 or 1
  color c;
  int newState;
  boolean added;
  Cell(int _state) {
    age = 0;
    state = _state;
    added = false;
  }
}


class Game {
  Cell[][] grid;
  int[][] capture;
  float w, h;
  int ncols, nrows;
  IntList lookAtMe = new IntList(); // all the cells that have changed

  Game(int _ncols, int _nrows) {
    ncols = _ncols;
    nrows = _nrows;
    w = 1.0 * width / ncols;
    h = 1.0 * height / nrows;
    grid = new Cell[ncols][nrows];
    capture = new int[ncols][nrows];
    lookAtMe.clear();
    for (int j = 0; j < nrows; j++) {
      for (int i = 0; i < ncols; i++) {
        grid[i][j] = new Cell(pattern[j*ncols + i]);
        capture[i][j]=grid[i][j].state;
        lookAtMe.append(j*ncols + i); //look at them all for first gen
      }
    }
  }

  void nextGeneration() {
    IntList newlookAtMe = new IntList();
    IntList dontlookAtMe = new IntList();

    for (int k : lookAtMe) {

      int i = k % ncols;
      int j = k / ncols;



      int numAlive = 0;
      for (int x = i-1; x <= i+1; x++) {
        for (int y = j-1; y <= j+1; y++) {
          if (x>=0 && y>=0 && x<ncols && y<nrows) numAlive += grid[x][y].state;
        }
      }
      grid[i][j].newState = getNewState(grid[i][j].state, numAlive - grid[i][j].state);


      if (grid[i][j].newState != grid[i][j].state) {
        for (int x = i-1; x <= i+1; x++) {
          for (int y = j-1; y <= j+1; y++) {
            if (x < 0 || y<0 || x>= ncols || y>= nrows) continue;
            if (grid[x][y].added == false) { 
              newlookAtMe.append(y*ncols + x); 
              //grid[x][y].age = 0;
            }
            grid[x][y].added = true;
          }
        }
      } 
      //else {

      //    if (delRule) {
      //      println("f");
      //      for (int x = i-1; x <= i+1; x++) {
      //        for (int y = j-1; y <= j+1; y++) {
      //          if (x < 0 || y<0 || x>= ncols || y>= nrows) continue;
      //          if (grid[x][y].added == false) {
      //            println(grid[x][y].age);

      //            if (grid[x][y].age>=6) {
      //              println("bp4");
      //              grid[x][y].state = 0;
      //              newlookAtMe.append(y*ncols + x);
      //              newlookAtMe.append(y*ncols + (x+1));
      //              newlookAtMe.append(y*ncols + (x-1));
      //              newlookAtMe.append((y-1)*ncols + x);
      //              newlookAtMe.append((y+1)*ncols + x);
      //              newlookAtMe.append((y-1)*ncols + (x+1));
      //              newlookAtMe.append((y+1)*ncols + (x+1));
      //              newlookAtMe.append((y-1)*ncols + (x-1));
      //              newlookAtMe.append((y+1)*ncols + (x-1));
      //              grid[x][y].age=0;
      //            } else {
      //              grid[x][y].age++;
      //              println(grid[x][y].age+"kj");
      //            }
      //          }
      //          grid[x][y].added = true;
      //        }
      //      }
      //    }
      //}
    }



    for (int k : lookAtMe) {
      //if(!(Arrays.asList(dontlookAtMe).contains(k))){
      int i = k % ncols;
      int j = k / ncols;

      grid[i][j].state = grid[i][j].newState;
      //}
    }


    if (frameCount%300==0) {
      for (int j = 0; j < nrows; j++) {
        for (int i = 0; i < ncols; i++) {
          //  capture[i][j]=0;
          int k = j*ncols + i;
          if (!(Arrays.asList(newlookAtMe).contains(k))  && grid[i][j].state==1) {
            //dontlookAtMe.append(k); 
            grid[i][j].state=0;
          }

          /*        if (lookAtMe.get(pos)==k||grid[i][j].newState == 0) {
           pos++;
           continue;
           }
           */

          //      capture[i][j]=grid[i][j].state;
          //    if (/*second()%10==0&&grid[i][j].state == grid[i][j].newState&&*/grid[i][j].state==capture[i][j]) {
          //      grid[i][j].state = 0;
          //    }
        }
      }
    }

    //lookAtMe.clear();
    lookAtMe = newlookAtMe;
  }

  int getNewState(int state, int numAlive) {

    if (state == 0) {
      if (numAlive == 3) return 1;
    }

    if (state == 1) {
      if (numAlive == 2 || numAlive == 3) return 1;
    }

    return 0;
  }


  void display() {
    color c;
    loadPixels();
    for (int k : lookAtMe) {
      int i = k % ncols;
      int j = k / ncols;
      if (grid[i][j].state == 1) c = color(255);
      else c = color(0);
      pixels[j*width + i] = c;
      grid[i][j].added = false;
    }
    updatePixels();
  }
}

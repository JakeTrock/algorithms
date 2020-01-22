ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  fullScreen();
  frameRate(120);
}


void draw() {
  background(245);
  PVector mouse = new PVector(mouseX, mouseY);
  if (frameCount%6==0)particles.add(new SquareParticle(mouse));
  if (frameCount%6==1)particles.add(new CirclePatricle(mouse));
  if (frameCount%6==2)particles.add(new TriangleParticle(mouse));

  for (Particle s : particles) {
    PVector gravAcc= new PVector(0, 0.2);
    PVector gravity= gravAcc.copy().mult(s.mass);
    s.applyForce(gravity);
    s.update();
  }
}





class Particle {
  PVector location, velocity, acceleration;
  color c;
  float lifespan, age, diameter, mass;

  Particle(PVector l) {
    location = l.copy();
    velocity = new PVector(random(-2, 2), random(-5, 0));
    acceleration = new PVector(0, 0);
    diameter = random(5, 15);
    mass = diameter / 5.0;
    age = 0;
    lifespan = 60;
    c = color(255, 0, 0);
  }

  void display() {
  }

  void update() {
    move();
    display();
    age++;
  }

  void move() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector f) {
    PVector a = f.copy().div(mass);
    acceleration.add(a);
  }

  boolean isDead() {
    if (age > lifespan) return true;
    return false;
  }
  class SquareParticle extends Particle {
    float angle;
    SquareParticle(PVector l) {
      super(l);
      angle = random(0, 2*PI);
    }
    void display() {
      stroke(0);
      fill(c, lifespan);
      pushMatrix();
      translate(location.x, location.y);
      rotate(angle);
      rect(0, 0, diameter, diameter);
      popMatrix();
    }
  }
  class TriangleParticle extends Particle {
    float angle;
    TriangleParticle(PVector l) {
      super(l);
      angle = random(0, 2*PI);
    }
    void display() {
      stroke(0);
      fill(c, lifespan);
      pushMatrix();
      translate(location.x, location.y);
      rotate(angle);
      triangle(diameter/2, diameter/2, -diameter/2, diameter/2, 0, -diameter/2);
      popMatrix();
    }
  }
  class CircleParticle extends Particle {
    float angle;
    CircleParticle(PVector l) {
      super(l);
      angle = random(0, 2*PI);
    }
    void display() {
      stroke(0);
      fill(c, lifespan);
      pushMatrix();
      translate(location.x, location.y);
      rotate(angle);
      ellipse(0,0,diameter,diameter);
      popMatrix();
    }
  }
}

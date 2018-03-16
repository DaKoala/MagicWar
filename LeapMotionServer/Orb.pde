abstract class Orb {
  PVector pos, vel;
  PImage[] look;
  
  Orb(float _posX, float _posY, float _velX, float _velY, PImage[] _look) {
    this.pos = new PVector(_posX, _posY);
    this.vel = new PVector(_velX, _velY);
    this.look = _look;
  }
  abstract void move();
  abstract void display();
}

class Fireball extends Orb {
  
   Fireball(float _posX, float _posY, float _velX, float _velY, PImage[] _look) {
     super(_posX, _posY, _velX, _velY, _look);
   }
   
   void move() {
     this.pos.add(this.vel); 
   }
   
   void display() {
     image(this.look[abs(frameCount % 8 - 4)], this.pos.x, this.pos.y); 
   }
}
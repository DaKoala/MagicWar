class Orb {
  PVector pos, vel;
  int size;
  int prior;
  PImage[] look;

  Orb(float _posX, float _posY, float _velX, float _velY, int _size, int _prior, PImage[] _look) {
    this.pos = new PVector(_posX, _posY);
    this.vel = new PVector(_velX, _velY);
    this.size = _size;
    this.prior = _prior;
    this.look = _look;
  }

  void move() {
    this.pos.add(this.vel);
  }

  void display() {
    image(this.look[abs(frameCount % 8 - 4)], this.pos.x, this.pos.y);
  }

  boolean collide(Orb that) {
    float dx = this.pos.x - that.pos.x;
    float dy = this.pos.y - that.pos.y;
    int ss = this.size + that.size;
    return dx * dx + dy * dy < ss * ss;
  }

  boolean collideMage(Mage that) {
    float dx = this.pos.x - that.pos.x;
    float dy = this.pos.y - that.pos.y;
    int ss = this.size + that.size;
    return dx * dx + dy * dy < ss * ss;
  }

  int compare(Orb that) {
    if      (this.prior > that.prior) return 1;
    else if (this.prior < that.prior) return -1;
    return 0;
  }
  
  boolean expire() {
    return (this.pos.x > 1750 || this.pos.x < -150); 
  }
}
class Orb {
  Mage master;
  PVector pos, vel;
  int size;
  int prior;
  int damage;
  PImage[] look;
  
  Orb(Mage _master, float _posX, float _posY, float _velX, float _velY, int _size, int _damage, int _prior, PImage[] _look) {
    this.master = _master;
    this.pos = new PVector(_posX, _posY);
    this.vel = new PVector(_velX, _velY);
    this.size = _size;
    this.damage = _damage;
    this.look = _look;
    this.prior = _prior;
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
  
  void hit(Mage other) {
    float base = this.damage * other.vul;
    if (other.state == Mage.BLOCK) {
      if      (this.prior == 0) base *= 0.2;
      else if (this.prior == 1) base *= 0.5;
      else                      base *= 0.8;
    }
    if (this.prior != 2) {
      this.master.superPower += (int) base * 20; 
    }
    other.health -= base;
  }
  
  int compare(Orb that) {
    if (this.prior > that.prior) {
      if (this.prior == 1) this.damage += that.damage;
      return 1;
    }
    else if (this.prior < that.prior) return -1;
    return 0;
  }
}
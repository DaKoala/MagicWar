class Mage {
  final static int STAND  = 0;
  final static int CAST   = 1;
  final static int BLOCK  = 2;
  final static int CHARGE = 3;
  
  PVector pos;
  float vel;
  int mana;
  int lstate, rstate, pr;
  int energy;
  int state;
  int orien;
  Listener listener;
  ArrayList<Orb> shots;
  PImage stand, charge, cast, block;

  Mage (float _posX, float _posY, float _vel, Listener _listener, ArrayList<Orb> _shots, PImage _stand, PImage _charge, PImage _cast, 
    PImage _block) {
    this.pos = new PVector(_posX, _posY);
    this.vel = _vel;
    this.mana = 0;
    this.lstate = 0;
    this.rstate = 0;
    this.energy = 0;
    this.listener = _listener;
    this.stand = _stand;
    this.charge = _charge;
    this.cast = _cast;
    this.block = _block;
    this.shots = _shots;
    this.orien = _posX < 800 ? 1 : -1;
  }

  void process() {
    int left = this.listener.getLeft();
    int right = this.listener.getRight();
    float hei = this.listener.getHeight();
    
    this.state = CAST;
    if (right == 0) {
      this.energy = 0;
    } 
    else if (right == 1 && this.mana >= 100) {
      if (this.pr != 1) this.energy = 0;
      else              this.energy++;
      if (this.energy == 20) {
        this.shots.add(new Fireball(this.pos.x, this.pos.y, 5 * this.orien, 0, fireballImg));
        this.mana -= 100;
      }
      this.pr = right;
      return;
    } 
    else if (right == 2 && this.mana >= 300) {
      if (this.pr != 2) this.energy = 0;
      else              this.energy++;
      if (this.energy == 30) {
        this.shots.add(new Fireball(this.pos.x, this.pos.y, 8 * this.orien, 0, thunderImg));
        this.mana -= 300;
      }
      this.pr = right;
      return;
    } 
    else if (right == 3 && this.mana >= 500) {
      if (this.pr != 3) this.energy = 0;
      else              this.energy++;
      if (this.energy == 50) {
        this.shots.add(new Fireball(this.pos.x, this.pos.y, 10 * this.orien, 0, doomImg));
        this.mana -= 500;
      }
      this.pr = right;
      return;
    }
    this.pr = 0;

    if (left == 0) {
      this.state = STAND;
      if (this.pos.y < hei - 10) this.pos.y += this.vel;
      else if (this.pos.y > hei + 10) this.pos.y -= this.vel;
    }
    else if (left == 1) {
      this.state = CHARGE;
      this.mana = this.mana >= 500 ? this.mana : this.mana + 1;
    } else {
      this.state = BLOCK;
    }
  }

  void display() {
    if      (this.state == CAST)   image(this.cast, this.pos.x, this.pos.y);
    else if (this.state == BLOCK)  image(this.block, this.pos.x, this.pos.y);
    else if (this.state == CHARGE) image(this.charge, this.pos.x, this.pos.y);
    else                           image(this.stand, this.pos.x, this.pos.y);
  }
}
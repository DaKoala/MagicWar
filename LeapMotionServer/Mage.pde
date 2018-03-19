class Mage {
  final static int STAND  = 0;
  final static int CAST   = 1;
  final static int BLOCK  = 2;
  final static int CHARGE = 3;
  
  PVector pos;
  float vel;
  int pr;
  int health, mana, superPower, energy;
  int state;
  int orien;
  int size;
  float vul;
  boolean stable;
  float stableHeight;
  Listener listener;
  ArrayList<Orb> shots;
  PImage stand, charge, cast, block;

  Mage (float _posX, float _posY, float _vel, int _size, Listener _listener, ArrayList<Orb> _shots, PImage _stand, PImage _charge, PImage _cast, 
    PImage _block) {
    this.pos = new PVector(_posX, _posY);
    this.vel = _vel;
    this.size = _size;
    
    this.health = 200;
    this.mana = 0; // most 500
    this.energy = 0;
    this.superPower = 0; // most 1500
    this.vul = 1;
    
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
    
    this.superPower++;
    this.superPower = constrain(this.superPower, 0, 1500);
    this.state = CAST;
    if (right == 0) {
      this.energy = 0;
      this.vul = 1;
    } 
    else if (right == 1 && this.mana >= 30) {
      this.vul = 1.5;
      if (this.pr != 1) this.energy = 0;
      else              this.energy++;
      if (this.energy == 20) {
        this.shots.add(new Orb(this, this.pos.x, this.pos.y, 5 * this.orien, 0, 50, 10, 0, fireballImg));
        this.mana -= 30;
      }
      this.pr = right;
      return;
    } 
    else if (right == 2 && this.mana >= 100) {
      this.vul = 1.5;
      if (this.pr != 2) this.energy = 0;
      else              this.energy++;
      if (this.energy == 30) {
        this.shots.add(new Orb(this, this.pos.x, this.pos.y, 8 * this.orien, 0, 75, 20, 1, thunderImg));
        this.mana -= 100;
      }
      this.pr = right;
      return;
    } 
    else if (right == 3 && this.superPower >= 1500) {
      this.vul = 1.5;
      if (this.pr != 3) this.energy = 0;
      else              this.energy++;
      if (this.energy == 50) {
        this.shots.add(new Orb(this, this.pos.x, this.pos.y, 10 * this.orien, 0, 125, 50, 2, doomImg));
        this.superPower = 0;
      }
      this.pr = right;
      return;
    }
    this.pr = 0;

    if (left == 0) {
      this.state = STAND;
      if (!this.stable && this.pos.y < hei - 10) {
        this.vel = this.vel >= 5 ? this.vel : this.vel + 0.2;
        this.pos.y += this.vel;
      }
      else if (!this.stable && this.pos.y > hei + 10) {
        this.vel = this.vel <= -5 ? this.vel : this.vel - 0.2;
        this.pos.y += this.vel;
      }
      else {
        this.vel = 0;
        if (!this.stable) this.stableHeight = this.pos.y;
        this.pos.y = this.stableHeight + 10 * sin(frameCount / 10.0);
        if (abs(hei - this.stableHeight) < 10) this.stable = true;
        else                                   this.stable = false;
      }
    }
    else if (left == 1) {
      this.vul = 1.5;
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
  
  void information() {
    int start = this.orien == 1 ? 20 : 1460;
    pushStyle();
    
    stroke(255, 0, 0);
    noFill();
    rect(start, 50, 120, 20);
    fill(255, 0, 0);
    rect(start, 50, 120 * (this.health / 200.0), 20);
    
    stroke(0, 0, 255);
    noFill();
    rect(start, 72, 120, 20);
    fill(0, 0, 255);
    rect(start, 72, 120 * (this.mana / 500.0), 20);
    
    stroke(255, 255, 0);
    noFill();
    rect(start, 94, 120, 20);
    fill(255, 255, 0);
    rect(start, 94, 120 * (this.superPower / 1500.0), 20);
  }
}
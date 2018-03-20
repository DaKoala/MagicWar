class Mage {
  final static int STAND  = 0;
  final static int CAST   = 1;
  final static int BLOCK  = 2;
  final static int CHARGE = 3;
  final static int MOV    = 4;
  
  PVector pos;
  float vel;
  int lstate, rstate, pr;
  int health, mana, superPower;
  int state;
  int size;
  int orien;
  PImage stand, charge, cast, block, mov;

  Mage (float _posX, float _posY, int _size, PImage _stand, PImage _charge, PImage _cast, PImage _block, PImage _mov) {
    this.pos = new PVector(_posX, _posY);
    this.size = _size;
    this.health = 200;
    this.mana = 0; // most 500
    this.superPower = 0; // most 1500    
    this.stand = _stand;
    this.charge = _charge;
    this.cast = _cast;
    this.block = _block;
    this.mov = _mov;
    this.state = 0;
    this.orien = _posX < 800 ? 1 : -1;
  }

  void display() {
    if      (this.state == CAST) {
      if (!castSpell.isPlaying()) castSpell.rewind();
      image(this.cast, this.pos.x, this.pos.y);
      castSpell.play();
    }
    else if (this.state == BLOCK)  image(this.block, this.pos.x, this.pos.y);
    else if (this.state == CHARGE) {
      if (!castSpell.isPlaying()) castSpell.rewind();
      image(this.charge, this.pos.x, this.pos.y);
      castSpell.play();
    }
    else if (this.state == MOV)    image(this.mov, this.pos.x, this.pos.y);
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
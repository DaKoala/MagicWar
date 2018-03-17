import processing.net.*; 

Client c; 
Server s;
OpListener opListener;
String input;
int data[];
JSONObject json = new JSONObject();
int energy = 0;
Mage me, oppo;
PImage[] fireballImg = new PImage[5];
PImage[] thunderImg = new PImage[5];
PImage[] doomImg = new PImage[5];
PImage rstandImg, rchargeImg, rcastImg, rblockImg, lstandImg, lchargeImg, lcastImg, lblockImg;
ArrayList<Orb> myOrbs = new ArrayList<Orb>();
ArrayList<Orb> oppoOrbs = new ArrayList<Orb>();


void setup() {
  leapSetup();
  size(1600, 900); 
  imageMode(CENTER);
  background(255);
  frameRate(45);
  //s = new Server(this, 8000);
  opListener = new OpListener();
  
  lstandImg = loadImage("mage/lstand.png");
  lchargeImg = loadImage("mage/lcharge.png");
  lcastImg = loadImage("mage/lcast.png");
  lblockImg = loadImage("mage/lblock.png");
  rstandImg = loadImage("mage/rstand.png");
  rchargeImg = loadImage("mage/rcharge.png");
  rcastImg = loadImage("mage/rcast.png");
  rblockImg = loadImage("mage/rblock.png");
  for (int i = 0; i < 5; i++) {
    thunderImg[i] = loadImage("orb/thunder" + i + ".png");
    fireballImg[i] = loadImage("orb/fireball" + i + ".png");
    doomImg[i] = loadImage("orb/doom" + i + ".png");
  }
  
  me = new Mage(1200, 400, 5, 100, listener, myOrbs, rstandImg, rchargeImg, rcastImg, rblockImg);
  oppo = new Mage(400, 400, 5, 100, opListener, oppoOrbs, lstandImg, lchargeImg, lcastImg, lblockImg);
} 

void draw() {
  background(100);
  leapDraw();
  //if (c.available() > 0) {
  //   input = c.readString();
  //   opListener.parseJSON(input);
  //}
  me.process();
  me.display();
  oppo.process();
  oppo.display();
  
  /* Handle collide */
  for (int i = myOrbs.size() - 1; i > -1; i--) {
    Orb mine = myOrbs.get(i);
    for (int j = oppoOrbs.size() - 1; j > -1; j--) {
      Orb its = oppoOrbs.get(j);
      if (mine.collide(its)) {
        int cmp = mine.compare(its);
        if      (cmp == 1)  oppoOrbs.remove(j);
        else if (cmp == -1) myOrbs.remove(i);
        else {
          myOrbs.remove(i);
          oppoOrbs.remove(j);
        }
        // TODO: Play sound
      }
    }
  }
  
  /* Handle damage */
  
}
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
ArrayList<Orb> orbs = new ArrayList<Orb>();


void setup() {
  leapSetup();
  size(1600, 900); 
  imageMode(CENTER);
  background(255);
  frameRate(45);
  s = new Server(this, 8000);
  opListener = new OpListener();
  
  rstandImg = loadImage("mage/rstand.png");
  rchargeImg = loadImage("mage/rcharge.png");
  rcastImg = loadImage("mage/rcast.png");
  rblockImg = loadImage("mage/rblock.png");
  for (int i = 0; i < 5; i++) {
    thunderImg[i] = loadImage("orb/thunder" + i + ".png");
    fireballImg[i] = loadImage("orb/fireball.png");
    doomImg[i] = loadImage("orb/doom" + i + ".png");
  }
  s = new Server(this, 8000);  // Start a simple server on a port
  
  me = new Mage(1200, 400, 5, listener, orbs, rstandImg, rchargeImg, rcastImg, rblockImg);
  oppo = new Mage(400, 400, 5, opListener, orbs, lstandImg, lstandImg, lcastImg, lblockImg);
} 

void draw() {
  background(100);
  leapDraw();
  if (c.available() > 0) {
     input = c.readString();
     opListener.parseJSON(input);
  }
  me.process();
  me.display();
  oppo.process();
  oppo.display();
  for (Orb ball : orbs) {
    ball.move();
    ball.display();
  }
}
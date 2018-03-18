import processing.net.*; 

Client c; 
Server s;
OpListener opListener;
String input;
int data[];
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
  rectMode(CORNER);
  frameRate(45);
  s = new Server(this, 8000);
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
  
  me = new Mage(1400, 400, 5, 100, listener, myOrbs, rstandImg, rchargeImg, rcastImg, rblockImg);
  oppo = new Mage(200, 400, 5, 100, opListener, oppoOrbs, lstandImg, lchargeImg, lcastImg, lblockImg);
} 

void draw() {
  JSONObject toClient = new JSONObject();
  JSONArray mages = new JSONArray();
  background(100);
  leapDraw();
  c = s.available();
  if (c != null) {
     input = c.readString();
     opListener.parseJSON(input);
  }
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
  
  /* Handle damage and display orbs */
  for (int i = myOrbs.size() - 1; i > -1; i--) {
    Orb mine = myOrbs.get(i);
    if (mine.collideMage(oppo)) {
      mine.hit(oppo);
      myOrbs.remove(i);
      continue;
      // TODO: Play sound
    }
    mine.move();
    mine.display();
  }
  for (int j = oppoOrbs.size() - 1; j > -1; j--) {
    Orb its = oppoOrbs.get(j);
    if (its.collideMage(me)) {
      its.hit(me);
      oppoOrbs.remove(j);
      continue;
      // TODO: Play sound
    }
    its.move();
    its.display();
  }
  me.information();
  oppo.information();
  
  mageJSON(mages, 0, me);
  mageJSON(mages, 1, oppo);
  toClient.setJSONArray("mages", mages);
  s.write(toClient.toString());
}

void mageJSON(JSONArray jarray, int index, Mage mage) {
  JSONObject jmage = new JSONObject();
  
  jmage.setFloat("height", mage.pos.y);
  jmage.setInt("state", mage.state);
  jmage.setInt("health", mage.health);
  jmage.setInt("mana", mage.mana);
  jmage.setInt("superPower", mage.superPower);
  
  jarray.setJSONObject(index, jmage);
}
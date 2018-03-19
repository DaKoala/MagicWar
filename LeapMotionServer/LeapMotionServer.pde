import processing.net.*; 

Client c; 
Server s;
OpListener opListener;
String input;
int stage = 0;
int myState = 1;
int oppoState = 0;
int data[];
int energy = 0;
Mage me, oppo;
PImage backgroundImg;
PImage[] fireballImg = new PImage[5];
PImage[] thunderImg = new PImage[5];
PImage[] doomImg = new PImage[5];
PImage onlineImg, offlineImg, waitingImg;
PImage rstandImg, rchargeImg, rcastImg, rblockImg, rmovImg, lstandImg, lchargeImg, lcastImg, lblockImg, lmovImg;
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
  onlineImg = loadImage("sign/online.png");
  waitingImg = loadImage("sign/waiting.png");
  offlineImg = loadImage("sign/offline.png");
  backgroundImg = loadImage("background.png");
  lstandImg = loadImage("mage/lstand.png");
  lchargeImg = loadImage("mage/lcharge.png");
  lcastImg = loadImage("mage/lcast.png");
  lblockImg = loadImage("mage/lblock.png");
  lmovImg = loadImage("mage/lmove.png");
  rstandImg = loadImage("mage/rstand.png");
  rchargeImg = loadImage("mage/rcharge.png");
  rcastImg = loadImage("mage/rcast.png");
  rblockImg = loadImage("mage/rblock.png");
  rmovImg = loadImage("mage/rmove.png");
  for (int i = 0; i < 5; i++) {
    thunderImg[i] = loadImage("orb/thunder" + i + ".png");
    fireballImg[i] = loadImage("orb/fireball" + i + ".png");
    doomImg[i] = loadImage("orb/doom" + i + ".png");
  }
  
  me = new Mage(1400, 400, 5, 100, listener, myOrbs, rstandImg, rchargeImg, rcastImg, rblockImg, rmovImg);
  oppo = new Mage(200, 400, 5, 100, opListener, oppoOrbs, lstandImg, lchargeImg, lcastImg, lblockImg, lmovImg);
} 

void draw() {
  if (stage == 0) {
    /* Online detection */
    background(0);
    leapDraw();
    c = s.available();
    if (c != null) {
      int inputNum = parseInt(c.readString());
      if (oppoState != 2) oppoState = 1;
      if (inputNum == 1) oppoState = 2;
    }
    if (listener.leftGrab > 0.8 && listener.rightGrab > 0.8) {
      s.write("1");
      myState = 2; 
    } 
    else {
      s.write("0"); 
    }
    
    if (myState == 2 && oppoState == 2) stage = 1;
    
    if (myState == 1) image(waitingImg, 200, 450);
    else              image(onlineImg, 200, 450);
    
    if      (oppoState == 0) image(offlineImg, 1400, 450);
    else if (oppoState == 1) image(waitingImg, 1400, 450);
    else                     image(onlineImg, 1400, 450);
    
    return;
  }
  
  JSONObject toClient = new JSONObject();
  JSONArray mages = new JSONArray();
  image(backgroundImg, 800, 450);
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
    if (mine.expire()) {
      myOrbs.remove(i); 
      continue;
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
    if (its.expire()) {
      oppoOrbs.remove(j);
      continue;
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

void init() {
  me = new Mage(1400, 400, 5, 100, listener, myOrbs, rstandImg, rchargeImg, rcastImg, rblockImg, rmovImg);
  oppo = new Mage(200, 400, 5, 100, opListener, oppoOrbs, lstandImg, lchargeImg, lcastImg, lblockImg, lmovImg);
  myOrbs = new ArrayList<Orb>();
  oppoOrbs = new ArrayList<Orb>();
}
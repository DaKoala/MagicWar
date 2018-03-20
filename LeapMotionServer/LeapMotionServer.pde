import processing.net.*; 
import ddf.minim.*;

Client c; 
Server s;
OpListener opListener;
String input;
int stage = 0;
int myState = 1;
int oppoState = 0;
boolean win = false;
Mage me, oppo;

Minim minim;
AudioPlayer battle;
AudioPlayer start;
AudioPlayer winner;
AudioPlayer loser;
AudioPlayer fireCast;
AudioPlayer thunderCast;
AudioPlayer doomCast;
AudioPlayer fireExp;
AudioPlayer thunderExp;
AudioPlayer doomExp;
AudioPlayer castSpell;

PFont font;
PImage titleImg;
PImage backgroundImg;
PImage[] fireballImg = new PImage[5];
PImage[] thunderImg = new PImage[5];
PImage[] doomImg = new PImage[5];
PImage onlineImg, offlineImg, waitingImg, winImg, loseImg;
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
  
  font = loadFont("AvenirNext-Heavy-48.vlw");
  textFont(font);
  textAlign(CENTER, CENTER);
  
  minim = new Minim(this);
  battle = minim.loadFile("sound/battle.mp3");
  start = minim.loadFile("sound/start.mp3");
  fireCast = minim.loadFile("sound/fire.wav");
  thunderCast = minim.loadFile("sound/thunder.wav");
  doomCast = minim.loadFile("sound/doom.wav");
  fireExp = minim.loadFile("sound/exp0.wav");
  thunderExp = minim.loadFile("sound/exp1.wav");
  doomExp = minim.loadFile("sound/exp2.wav");
  castSpell = minim.loadFile("sound/cast.wav");
  
  titleImg = loadImage("sign/title.png");
  winImg = loadImage("sign/win.png");
  loseImg = loadImage("sign/lose.png");
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
    if (!start.isPlaying()) start.play();
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
    } else {
      s.write("0");
    }

    if (myState == 2 && oppoState == 2) stage = 1;
    
    image(titleImg, 800, 150);
    textSize(48);
    fill(255);
    text("Player 1", 210, 300);
    if (myState == 1) image(waitingImg, 200, 450);
    else              image(onlineImg, 200, 450);
    
    text("Player 2", 1390, 300);
    if      (oppoState == 0) image(offlineImg, 1400, 450);
    else if (oppoState == 1) image(waitingImg, 1400, 450);
    else                     image(onlineImg, 1400, 450);
    
    fill(255, abs((frameCount * 4) % 510 - 255));
    textSize(60);
    text("Grab both hands to get ready", 800, 800);

    return;
  }

  if (stage == 2) {
    /* Online detection */
    background(0);
    
    if (win) {
      image(winImg, 800, 200);
      winner.play();
    }
    else {
      image(loseImg, 800, 200);
      loser.play();
    }
    
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
    else if (win) {
      s.write("8");
    }
    else {
      s.write("9"); 
    }

    if (myState == 2 && oppoState == 2) {
      init();
      stage = 1;
    }

    if (myState == 1) image(waitingImg, 200, 450);
    else              image(onlineImg, 200, 450);

    if      (oppoState == 0) image(offlineImg, 1400, 450);
    else if (oppoState == 1) image(waitingImg, 1400, 450);
    else                     image(onlineImg, 1400, 450);
    
    fill(255, abs((frameCount * 4) % 510 - 255));
    textSize(60);
    text("Play again? Grab your hands!", 800, 800);

    return;
  }
  if (start.isPlaying()) {
    start.pause();
    battle.loop();
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
        if      (cmp == 1)  explode(oppoOrbs, j);
        else if (cmp == -1) explode(myOrbs, i);
        else {
          explode(myOrbs, i);
          explode(oppoOrbs, j);
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
      explode(myOrbs, i);
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
      explode(oppoOrbs, j);
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

  if (me.health <= 0 || oppo.health <= 0) {
    if (me.health <= 0) win = false;
    else                win = true;
    stage = 2;
    myState = 1;
    oppoState = 1;
    return;
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
  myOrbs.clear();
  oppoOrbs.clear();
}

void explode(ArrayList<Orb> orbs, int index) {
  int prior = orbs.get(index).prior;
  AudioPlayer thisSound;
  if      (prior == 0) thisSound = fireExp;
  else if (prior == 1) thisSound = thunderExp;
  else                 thisSound = doomExp;
  thisSound.play();
  thisSound.rewind();
  orbs.remove(index);
}
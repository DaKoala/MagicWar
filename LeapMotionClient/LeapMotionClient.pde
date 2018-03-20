import processing.net.*; 

Client c; 
String input;
JSONObject output = new JSONObject();
Mage me, oppo;
int stage = 0;
int myState = 1;
int oppoState = 1;
boolean win = false;
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
  size(1600, 900); 
  background(204);
  imageMode(CENTER);
  rectMode(CORNER);
  frameRate(45); // Slow it down a little
  font = createFont("AvenirNext-Heavy-48", 48);
  textFont(font);
  textAlign(CENTER, CENTER);
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
  leapSetup();
  me = new Mage(1400, 400, 100, rstandImg, rchargeImg, rcastImg, rblockImg, rmovImg);
  oppo = new Mage(200, 400, 100, lstandImg, lchargeImg, lcastImg, lblockImg, lmovImg);
  // Connect to the server’s IP address and port­
  c = new Client(this, "169.254.10.41", 8000); // Replace with your server’s IP and port
} 

void draw() {
  if (stage == 0) {
    /* Online detection */
    background(0);
    leapDraw();
    if (c.available() > 0) {
      int inputNum = parseInt(c.readString());
      if (myState != 2) myState = 1;
      if (inputNum == 1) myState = 2;
    }
    if (listener.leftGrab > 0.8 && listener.rightGrab > 0.8) {
      oppoState = 2; 
    }
    
    if (oppoState == 2) {
      c.write("1");
    }
    else {
      c.write("0"); 
    }

    
    if (myState == 2 && oppoState == 2) stage = 1;
    
    image(titleImg, 800, 200);
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
    background(0);
    
    if (win) image(winImg, 800, 200);
    else     image(loseImg, 800, 200);
    
    leapDraw();
    if (c.available() > 0) {
      int inputNum = parseInt(c.readString());
      if (myState != 2) myState = 1;
      if (inputNum == 1) myState = 2;
    }
    if (listener.leftGrab > 0.8 && listener.rightGrab > 0.8) {
      oppoState = 2; 
    }
    
    if (oppoState == 2) {
      c.write("1");
    }
    else {
      c.write("0"); 
    }

    
    if (myState == 2 && oppoState == 2) {
      init();
      stage = 1;
    }
    
    image(titleImg, 800, 200);
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
    text("Play again? Grab your hands!", 800, 800);
    
    return; 
  }
  
  
  
  image(backgroundImg, 800, 450);
  leapDraw();
  output.setInt("left", listener.getLeft());
  output.setInt("right", listener.getRight());
  output.setFloat("leftHeight", listener.leftHeight);
  c.write(output.toString());

  if (c.available() > 0) {
    input = c.readString();
    if (input.length() < 2 && (me.health < 100 || oppo.health < 100)) {
      int result = parseInt(input);
      if (result == 8) {
        win = false;
        stage = 2;          
        myState = 1;
        oppoState = 1;
        return;
      }
      else if (result == 9) {
        win = true;
        stage = 2;          
        myState = 1;
        oppoState = 1;
        return;
      }
    }
  }
  JSONObject fromServer = parseJSON(input);
  if (!fromServer.equals(new JSONObject())) {
    JSONArray mages = fromServer.getJSONArray("mages");
    try {
      setMage(mages.getJSONObject(0), me, myOrbs);
      setMage(mages.getJSONObject(1), oppo, oppoOrbs);
    } 
    catch(Exception e) {
      println("Fail");
    }
  }
  
  if (me.health <= 0 || oppo.health <= 0) {
    if (me.health <= 0) win = true;
    else                win = false;
    stage = 2;
    myState = 1;
    oppoState = 1;
    return;
  }

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

  me.display();
  oppo.display();
  me.information();
  oppo.information();
  
}

JSONObject parseJSON(String jString) {
  JSONObject result = new JSONObject();
  boolean success = true;
  try {
    result = parseJSONObject(jString);
  } 
  catch(Exception e) {
    success = false;
  }
  return result;
}

void setMage(JSONObject j, Mage m, ArrayList<Orb> orbs) {
  m.pos.y = j.getFloat("height");
  m.state = j.getInt("state");
  m.health = j.getInt("health");
  int newMana = j.getInt("mana");
  if (newMana >= m.mana) {
    ;
  } else if (m.mana - newMana >= 99) {
    orbs.add(new Orb(m.pos.x, m.pos.y, 8 * m.orien, 0, 75, 2, thunderImg));
  } else {
    orbs.add(new Orb(m.pos.x, m.pos.y, 5 * m.orien, 0, 50, 1, fireballImg));
  }
  m.mana = newMana;
  int newSuperPower = j.getInt("superPower");
  if (newSuperPower >= m.superPower) {
    ;
  } else if (newSuperPower < 5) {
    orbs.add(new Orb(m.pos.x, m.pos.y, 10 * m.orien, 0, 125, 3, doomImg));
  }
  m.superPower = newSuperPower;
}

void init() {
  me = new Mage(1400, 400, 100, rstandImg, rchargeImg, rcastImg, rblockImg, rmovImg);
  oppo = new Mage(200, 400, 100, lstandImg, lchargeImg, lcastImg, lblockImg, lmovImg);
  myOrbs.clear();
  oppoOrbs.clear();
}
import processing.net.*; 

Client c; 
String input;
JSONObject output = new JSONObject();
Mage me, oppo;
int stage = 0;
int myState = 1;
int oppoState = 1;
PImage backgroundImg;
PImage[] fireballImg = new PImage[5];
PImage[] thunderImg = new PImage[5];
PImage[] doomImg = new PImage[5];
PImage onlineImg, offlineImg, waitingImg;
PImage rstandImg, rchargeImg, rcastImg, rblockImg, rmovImg, lstandImg, lchargeImg, lcastImg, lblockImg, lmovImg;
ArrayList<Orb> myOrbs = new ArrayList<Orb>();
ArrayList<Orb> oppoOrbs = new ArrayList<Orb>();

void setup() { 
  size(1600, 900); 
  background(204);
  imageMode(CENTER);
  rectMode(CORNER);
  frameRate(45); // Slow it down a little
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
      input = c.readString();
      if (myState != 2) myState = 1;
      if (input == "1") myState = 2;
    }
    if (listener.leftGrab > 0.8 && listener.rightGrab > 0.8) {
      c.write("1");
      oppoState = 2; 
    }
    else {
      c.write("0");
    }
    
    if (myState == 2 && oppoState == 2) stage = 1;
    
    if (myState == 1) image(waitingImg, 200, 450);
    else              image(onlineImg, 200, 450);
    
    if      (oppoState == 0) image(offlineImg, 1400, 450);
    else if (oppoState == 1) image(waitingImg, 1400, 450);
    else                     image(onlineImg, 1400, 450);
    
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

void showOrbs(ArrayList<Orb> orbs) {
  for (Orb o : orbs) {
    o.move();
    o.display();
  }
}
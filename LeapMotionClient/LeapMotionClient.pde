import processing.net.*; 

Client c; 
String input;
JSONObject output = new JSONObject();
Mage me, oppo;
PImage[] fireballImg = new PImage[5];
PImage[] thunderImg = new PImage[5];
PImage[] doomImg = new PImage[5];
PImage rstandImg, rchargeImg, rcastImg, rblockImg, lstandImg, lchargeImg, lcastImg, lblockImg;
ArrayList<Orb> myOrbs = new ArrayList<Orb>();
ArrayList<Orb> oppoOrbs = new ArrayList<Orb>();

void setup() { 
  size(1600, 900); 
  background(204);
  frameRate(45); // Slow it down a little
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
  leapSetup();
  me = new Mage(1400, 400, rstandImg, rchargeImg, rcastImg, rblockImg);
  oppo = new Mage(200, 400, lstandImg, lchargeImg, lcastImg, lblockImg);
  // Connect to the server’s IP address and port­
  c = new Client(this, "169.254.10.41", 8000); // Replace with your server’s IP and port
} 

void draw() {
  background(100);
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
    setMage(mages.getJSONObject(0), me);
    setMage(mages.getJSONObject(1), oppo);
    } catch(Exception e) {
      println("Fail"); 
    }
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
  } catch(Exception e) {
    success = false; 
  }
  return result;
}

void setMage(JSONObject j, Mage m) {
  m.pos.y = j.getFloat("height");
  m.state = j.getInt("state");
  m.health = j.getInt("health");
  m.mana = j.getInt("mana");
  m.superPower = j.getInt("superPower");
}
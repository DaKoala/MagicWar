import processing.net.*; 

Client c; 
JSONObject output = new JSONObject();

void setup() { 
  size(450, 255); 
  background(204);
  frameRate(60); // Slow it down a little
  leapSetup();
  // Connect to the server’s IP address and port­
  c = new Client(this, "169.254.10.41", 8000); // Replace with your server’s IP and port
} 

void draw() {
  leapDraw();
  output.setInt("left", listener.getLeft());
  output.setInt("right", listener.getRight());
  output.setFloat("leftHeight", listener.leftHeight);
  c.write(output.toString());
}
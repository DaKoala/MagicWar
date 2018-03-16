import de.voidplus.leapmotion.*;
LeapMotion leap;
Listener listener;

class Listener {
  boolean leftCircle;
  boolean leftFound, rightFound;
  int leftIndexId;
  int leftState, rightState;
  float leftGrab, rightGrab, rightPinch;
  float leftHeight;

  Listener() {
    this.leftCircle = false;
    this.leftIndexId = -1;
    this.leftState = -1;
    this.rightState = -1;
    this.leftGrab = 0;
    this.rightGrab = 0;
    this.rightPinch = 0;
    this.leftHeight = 0;
  }

  void reset() {
    this.leftIndexId = -1;
    this.leftFound = false;
    this.rightFound = false;
  }

  int getLeft() {
    if (!this.leftFound) return 0; // Default

    if (this.leftCircle) {
      this.leftCircle = false;
      return 1; // Charge
    } else if (this.leftGrab > 0.8) return 4; // Block

    return 0; //
  }

  int getRight() {
    if (!this.rightFound) return 0;

    if (this.rightState == 2) return 1;
    else if (this.rightGrab > 0.8) return 3;
    else if (this.rightPinch > 0.8) return 2;


    return 0;
  }
}

class OpListener extends Listener {
  int left, right;
  float leftHeight;

  OpListener() {
    this.left = 0;
    this.right = 0;
    this.leftHeight = 0;
  }

  int getLeft() {
    return this.left;
  }

  int getRight() {
    return this.right;
  }

  void parseJSON(String Jstr) {
    boolean success = true;
    JSONObject Jobj = new JSONObject();
    try {
      Jobj = parseJSONObject(Jstr);
      this.left = Jobj.getInt("left");
      this.right = Jobj.getInt("right");
      this.leftHeight = Jobj.getInt("leftHeight");
    } 
    catch(Exception e) {
      success = false;
    } 
    finally {
      if (!success) {
        this.left = 0;
        this.right = 0;
      }
    }
  }
}

void leapSetup() {
  leap = new LeapMotion(this).allowGestures("circle");
  listener = new Listener();
}

void leapDraw() {
  listener.reset();
  for (Hand hand : leap.getHands ()) {
    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
    float   handHeight         = hand.getStabilizedPosition().y;
    float   handGrab           = hand.getGrabStrength();
    float   handPinch          = hand.getPinchStrength();
    int     fingerState        = 0;

    for (Finger finger : hand.getOutstretchedFingers()) {
      // or              hand.getFingers();
      // or              hand.getOutstretchedFingersByAngle();
      switch(finger.getType()) {
      case 0:
        // System.out.println("thumb");
        fingerState += 1;
        break;
      case 1:
        // System.out.println("index");
        fingerState += 2;
        if (handIsLeft) listener.leftIndexId = finger.getId();
        break;
      case 2:
        // System.out.println("middle");
        fingerState += 4;
        break;
      case 3:
        // System.out.println("ring");
        fingerState += 8;
        break;
      case 4:
        // System.out.println("pinky");
        fingerState += 16;
        break;
      }
    }
    if (handIsLeft) {
      listener.leftFound = true;
      listener.leftGrab = handGrab;
      listener.leftState = fingerState;
      listener.leftHeight = handHeight;
    } else {
      listener.rightFound = true;
      listener.rightGrab = handGrab;
      listener.rightPinch = handPinch;
      listener.rightState = fingerState;
    }
  }
}

void leapOnCircleGesture(CircleGesture g, int state) {
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector positionCenter   = g.getCenter();
  float   radius           = g.getRadius();
  float   progress         = g.getProgress();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();
  int     direction        = g.getDirection();

  switch(state) {
  case 1: // Start
    break;
  case 2: // Update
    if (finger.getId() == listener.leftIndexId) {
      listener.leftCircle = true;
    }
    break;
  case 3: // Stop
    //println("CircleGesture: " + id);
    break;
  }

  switch(direction) {
  case 0: // Anticlockwise/Left gesture
    break;
  case 1: // Clockwise/Right gesture
    break;
  }
}
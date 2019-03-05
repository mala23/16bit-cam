import mqtt.*;

MQTTClient client;

int[] distances = new int[12];

void setup() {
  size(800, 600);
  client = new MQTTClient(this);
  client.connect("mqtt://192.168.2.37:1884", "processing");
}

void draw() {
  int w = width/4;
  int h = height/3;

  for(int y=0; y<3; y++) {
    for(int x=0; x<4; x++) {
      int loc = x + y * 4;
      int d = distances[loc];

      fill(map(d, 0, 1500, 255, 0));
      rect(x * w, y * h, w, h);
    }
  }
}

void clientConnected() {
  println("client connected");
  client.subscribe("+/dst");
}

void messageReceived(String topic, byte[] payload) {
  String str = new String(payload);
  int distance = int(str);
  String[] segments = split(topic, "/");
  int id = int(segments[0]);

  distances[id] = distance;

  println(id + ":" + distance);
}

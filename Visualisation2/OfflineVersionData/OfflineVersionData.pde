/* Sandie Vervondel
   3Ba Multec AT
   2018-2019
*/

//Backup for when internet or API call (different file) doesn't work
import oscP5.*;
import netP5.*;
OscP5 osc;
NetAddress address;
int index;
Table exchangeRates;
PFont font;

void setup(){
 size(1500, 900);
 background(255);font = createFont("Money Money Plus", 50);
 textFont(font);
 textAlign(CENTER);
 fill(255,255,0);
 osc = new OscP5(this, 12000);
 address = new NetAddress("127.0.0.1", 12000);
 index = 0;
 exchangeRates = loadTable("exchangerates.csv", "header");
}

// A function that creates a new OSC message and sends it to the previously chosen address
void sendOsc(float price){
  OscMessage message = new OscMessage("/Exchangerate");
  message.add(price);
  osc.send(message, address);
}

void drawBackground(){
  stroke(255,255,0);
  fill(0);
  
  rect(50, 50, width-100, height-100);
  rect(75, 75, width-150, height-150);
  ellipse(0, 0, 210, 210);
  ellipse(0, height, 210, 210);
  ellipse(width, 0, 210, 210);
  ellipse(width, height, 210, 210);
  ellipse(0, 0, 160, 160);
  ellipse(0, height, 160, 160);
  ellipse(width, 0, 160, 160);
  ellipse(width, height, 160, 160);
  
  fill(255,255,0);
}

void draw(){
  // Clear screen
  background(0);
  // Wait a second
  delay(1000);
  drawBackground();
  TableRow row = exchangeRates.getRow(index);
  float rate = row.getFloat("rate");
  String value = row.getString("values");
  String time = row.getString("time");
  // Create text to show on screen
  String toPrint = value+ ": " + rate;
  text(toPrint, 50, height/2 -50, width-100, 300);
  // Call OSC function
  sendOsc(rate);
  println(value + ": " + rate);
  text(time, 50, height/2 +50, width-100, 300); 
  index++;
  // Check if the index isn't bigger than the amount of items in the array
  if(index >= exchangeRates.getRowCount()){
    index = 0;
  }
}
 
  
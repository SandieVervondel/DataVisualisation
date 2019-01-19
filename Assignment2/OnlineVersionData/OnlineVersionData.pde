/* Sandie Vervondel
   3Ba Multec AT
   2018-2019
*/

// TO DO: display current exchange rate, pair, converted timestamp (and currency in words) --> better design

import oscP5.*;
import netP5.*;
String[] exchangeValues = {"Euro to American dollar", "Euro to pound sterling", "Euro to Swiss franc", "Euro to Canadian dollar", "Euro to Australian dollar", "Euro to New Zealand dollar", "Euro to Japanese yen", "Euro to Norwegian krone", "Euro to Russian ruble", "Euro to Swedish krona", "Euro to Singapore dollar", "Euro to Turkish lira", "Euro to South African rand", "Euro to Hong Kong dollar", "Euro to Renminbi", "Euro to Danish krone", "Euro to Mexican peso", "Euro to Polish zloty", "Silver value in Euro", "Gold value in Euro", "Euro to Bitcoin", "Euro to Ether", "Euro to Litecoin", "Euro to XRP", "Euro to Dashcoin", "Euro to Bitcoin Cash"};
float[] exchangeRates = new float[exchangeValues.length];
OscP5 osc;
NetAddress address;
int index;
String time;
PFont font;

/*
Create the back-up file
Table table;
int loops;*/

void setup(){
 size(1500, 900);
 background(255);
 font = createFont("Money Money Plus", 50);
 textFont(font);
 textAlign(CENTER);
 fill(255,255,0);
 osc = new OscP5(this, 12000);
 address = new NetAddress("127.0.0.1", 12000);
 index = 0;
 
 /*
 Create the back-up file
 table = new Table();
 table.addColumn("rate");
 table.addColumn("values");
 table.addColumn("time");
 loops = 0;*/
}

// A function that gets all the prices for the Euro pairs and put them in an array
void getExchangeRate(){
  // Code to load API from: https://processing.org/tutorials/data/
  JSONArray json = loadJSONArray("https://forex.1forge.com/1.0.3/quotes?pairs=EURUSD,EURGBP,EURCHF,EURCAD,EURAUD,EURNZD,EURJPY,EURNOK,EURRUB,EURSEK,EURSGD,EURTRY,EURZAR,EURHKD,EURCNH,EURDKK,EURMXN,EURPLN,EURXAG,EURXAU,EURBTC,EURETH,EURLTC,EURXRP,EURDSH,EURBCH&api_key=8ilCLULjbefC5Lo4gl7OM1xb8oWXpEWg");
  // The timestamp is the same for each of the requested pairs, so we only need to save one of those
  JSONObject firstRate = json.getJSONObject(0);
  int timestamp = firstRate.getInt("timestamp");
  // Code to convert timestamp from: https://processing.org/discourse/beta/num_1227390650.html
  // Convert the timestamp to a more readable format
  time = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date (timestamp*1000L));
  // Loop over the array with all the pairs and put the corresponding price into the exchangeRates array 
  for(int i = 0; i<exchangeValues.length; i++){
    JSONObject rates = json.getJSONObject(i);
    exchangeRates[i] = rates.getFloat("price");
  } 
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
  // Only get the exchange rates when the index is 0
  if(index == 0){
    getExchangeRate();
  }
  // Clear screen
  background(0);
  // Wait a second
  delay(1000);
  drawBackground();
  // Create text to show on screen
  String toPrint = exchangeValues[index]+ ": " + exchangeRates[index];
  text(toPrint, 50, height/2 - 50, width-100, 300);
  // Call OSC function
  sendOsc(exchangeRates[index]);
  println(exchangeValues[index] + ": " + exchangeRates[index]);
  /*
  Create the back-up file
  TableRow row = table.addRow();
  row.setFloat("rate", exchangeRates[index]);
  row.setString("values", exchangeValues[index]);
  row.setString("time", time);*/
  text(time, 50, height/2 + 50, width-100, 300); 
  index++;
  // Check if the index isn't bigger than the amount of items in the array
  if(index >= exchangeValues.length){
    index = 0;
    //loops++;
  }
  /*if(loops >= 20){
    saveTable(table, "data/exchangerates.csv");
    exit();
  }*/
}
 
  
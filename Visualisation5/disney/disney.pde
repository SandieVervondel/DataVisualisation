/*
Sandie Vervondel
3Ba Multec AT
2018-2019
*/
Table disney;
float min = 600000000;
float max = 0;
int maxMap = 1000;
int year= 1937;
Movie[] movies;
int delay = 500;
int textHeight = 925;
int textDiff = 25;
PFont disneyfont;


void setup(){
  size(1500, 1000);
  disney = loadTable("disney.csv", "header");
  movies = new Movie[disney.getRowCount()];
  disneyfont = createFont("waltograph42.otf", 10);
  textFont(disneyfont);
  textSize(30);
  strokeWeight(3);
  getMovies();
}


void draw(){
  delay(delay);
  background(255);
  fill(240);
  noStroke();
  // This circle shows the boundaries of the "graph"
  ellipse(width/2, height/2, maxMap, maxMap);
  noFill();
  // Loop over table to find all the movies with the same year
  for(int i = 0; i < disney.getRowCount(); i++){
    // Have the length of the line that shows the values for each movie change 
    float y = 0;
    if(i%2 == 0){
      y = 275;
    }
    if(i%2 == 1){
      y = 335;
    }
    if(movies[i].year == year){
      movies[i].drawMovie(y);
    }
  }
  textFont(disneyfont);
  
  // Create all the text on the side
  textSize(50);
  textAlign(LEFT);
  fill(0);
  text(year, 75, 100);
  textSize(30);
  text("Genres:", 75, textHeight - 13*textDiff);
  textSize(25);
  fill(128,0,0);
  text("Musical", 75, textHeight - 12*textDiff);
  fill(0,0,117);
  text("Adventure", 75, textHeight - 11*textDiff);
  fill(245,130,49);
  text("Western", 75, textHeight - 10*textDiff);
  fill(145,30,180);
  text("Thriller/Suspense", 75, textHeight - 9*textDiff);
  fill(230,25,75);
  text("Romantic Comedy", 75, textHeight - 8*textDiff);
  fill(128,128,0);
  text("Horror", 75, textHeight - 7*textDiff);
  fill(70,240,240);
  text("Drama", 75, textHeight - 6*textDiff);
  fill(188,246,12);
  text("Documentary", 75, textHeight - 5*textDiff);
  fill(0,128,128);
  text("Concert/Performance", 75, textHeight - 4*textDiff);
  fill(67,99,216);
  text("Comedy", 75, textHeight - 3*textDiff);
  fill(255,225,25);
  text("Black Comedy", 75, textHeight - 2*textDiff);
  fill(60,180,75);
  text("Action", 75, textHeight - 1*textDiff);
  fill(0);
  text("Unknown", 75, textHeight);
  
  // If there are no movies in the current year, the time will pass faster
  // If there are a lot of movies, the time will pass slower
  int amountOfMovies = 0;
  for(TableRow row : disney.findRows(str(year), "release_date")){
    amountOfMovies++;
  }
  println(amountOfMovies);
  if(amountOfMovies == 0){
    delay = 500;
  }else if(amountOfMovies >= 15){
    delay = 6000;
  }else{
    delay = 4000;
  }
  year++;
  // The last year of which there is data is 2016, if the year passed 2016 the graph resets to it's original year
  if(year >= 2017){
    year = 1937;
  }
  
}

// Function that fills the movies array with the data from disney.csv
void getMovies(){
  // Fill the movies array with 
  for(int i = 0; i < disney.getRowCount(); i++){
    TableRow row = disney.getRow(i);
    String name = row.getString("movie_title");
    int year = row.getInt("release_date");
    String genre = row.getString("genre");
    float radius = row.getFloat("divided");
    int red = 50;
    int green = 50;
    int blue = 50;
    min = min(min, radius);
    max = max(max, radius);
    // Change the values of red, green and/or blue depending on the genre of the movie
    if(genre.equals("Musical")){
      red = 128;
    }
    else if(genre.equals("Adventure")){
      blue = 117;
    }
    else if(genre.equals("Western")){
      red = 245;
      green = 130;
      blue = 49;
    }
    else if(genre.equals("Thriller/Suspense")){
      red = 145;
      green = 30;
      blue = 180;
    }
    else if(genre.equals("Romantic Comedy")){
      red = 230; 
      green = 25;
      blue = 75;
    }
    else if(genre.equals("Horror")){
      red = 128;
      green = 128;
    }
    else if(genre.equals("Drama")){
      red = 70;
      green = 240;
      blue = 240;
    }
    else if(genre.equals("Documentary")){
      red = 188;
      green = 246;
      blue = 12;
    }
    else if(genre.equals("Concert/Performance")){
      green = 128;
      blue = 128;
    }
    else if(genre.equals("Comedy")){
      red = 67;
      green = 99;
      blue = 216;
    }
    else if(genre.equals("Black Comedy")){
      red = 255;
      green = 255;
      blue = 25;
    }
    else if(genre.equals("Action")){
      red = 60;
      green = 180;
      blue = 75;
    }
    else if(genre.equals("Unknown")){
      red = 0;
      green = 0;
      blue = 0;
    }
    // Create instance of the Movie class and puts it in the array
    movies[i] = new Movie(name, year, red, green, blue, radius, i);
  }
}


class Movie{
  String name;
  public int year;
  public int red;
  public int green;
  public int blue;
  public float radius;
  int index;
  
  public Movie(String newName, int newYear, int newRed, int newGreen, int newBlue, float newRadius, int newIndex){
    name = newName;
    year = newYear;
    red = newRed;
    green = newGreen;
    blue = newBlue;
    radius = newRadius;
    index = newIndex;
  }
  
  public void drawMovie(float y){
    
    stroke(red, green, blue);
    // Map the radius values to smaller values so they can be used as the width and height of the ellipse
    float mappedRadius = map(radius, min, max, 1, maxMap);
    // Make sure each name always fits the line
    float minLength = name.length() *1.8;
    PFont font = createFont("Arial",12);
    textFont(font);
    //textSize(20);
    // We want to create a line that goes from the side of the circle to another point and shows the 
    // corresponding movie title and inflation adjusted gross for each circle.
    // To make sure these values in text form don't overlap as much as would normally, we will rotate our
    // canvas for each circle.
    pushMatrix();
    translate(width/2,height/2);
    rotate(TWO_PI/32*index*1.5);
    line(mappedRadius/2, 0, mappedRadius/2, minLength+y);
    translate(mappedRadius/2,minLength+y);
    rotate(HALF_PI);
    textAlign(RIGHT);
    fill(0);
    text(name, 0, -5);
    textAlign(LEFT);
    // Multiply the value by 1000 since the original values from the csv were to large to store, 
    // so I devided those by 1000 in the file itself
    text("$"+round(radius*1000),5,-5);
    popMatrix();
    noFill();
    ellipse(width/2, height/2, mappedRadius, mappedRadius);
    
  }

}
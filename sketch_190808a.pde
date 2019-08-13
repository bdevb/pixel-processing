PImage image;
PGraphics pg;

float threshold = 30.0;
int r = 2;

HashMap<Integer, Integer> hash = new HashMap<Integer, Integer>();

void setup(){
  size(500, 500);
  
  image = loadImage("84170952-b.jpg");
  image.loadPixels();
  pg = createGraphics(500, 500);
  
  loadRects();
}

void draw(){
  background(255);
  image(pg, 0, 0);
}

void loadRects(){
  hash = new HashMap<Integer, Integer>();
  
  pg.beginDraw();
  pg.background(100);
  
  pg.stroke(0, 50);
  //pg.noStroke();
  
  for(int i=r; i<image.width; i+=r){
    for(int j=r; j<image.height; j+=r){
      int c=0;
      //confronto di colori
      color fcolor = getColor(image.get(i-r/2, j-r/2));
      
      if(hash.containsKey(fcolor)){
        c = hash.get(fcolor);
      }
      hash.put(fcolor,c+1);
      
      pg.fill(fcolor);
      pg.rect(i-r, j-r, r, r);
      
    }
  }
  pg.endDraw();
  
  println("----------- COLORS ------------");  
  for (Integer k: hash.keySet()){
    color argb = k;
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)
    println(r +"," +g +"," +b + " " + hash.get(k));  
  } 
  println("-------------------------------");  
}

color getColor(color c1){
  float mindc = 1000.f;
  color bestc = -1;
  
  for (Integer k: hash.keySet()){
    color c2 = k;
    
    float r = (red(c1) + red(c2))/2.f;
    float dr = red(c1) - red(c2);
    float dg = green(c1) - green(c2);
    float db = blue(c1) - blue(c2);
    
    float dc = sqrt(((2 + r/256) * sq(dr)) + (4 * sq(dg)) + ((2 + (255-r)/256) * sq(db)));
    //println(dc);
    if(mindc > dc){
      mindc = dc;
      bestc = c2;
    }
  }
  
  if(bestc != -1 && mindc < threshold) //println("Colori simili");
    return bestc;
  //else println("Colori differenti");
  return c1;
}

void mouseClicked() {
  r++;
  loadRects();
  loop();
}

/*
void setup(){
  size(300, 300);
  
  color c1 = color(255, 255, 0);
  color c2 = color(255,127, 0);
  println(red(c1) +"," +  green(c1) +"," +blue(c1) );
  println(red(c2) +"," +  green(c2) +"," +blue(c2) );
  
  float r = (red(c1) + red(c2))/2.f;
  float dr = red(c1) - red(c2);
  float dg = green(c1) - green(c2);
  float db = blue(c1) - blue(c2);
  
  float dc = sqrt(((2 + r/256) * sq(dr)) + (4 * sq(dg)) + ((2 + (255-r)/256) * sq(db)));
  println(dc);
  float threshold = 220.0;
  if(dc < threshold) println("Colori simili");
  else println("Colori differenti");
  
  noStroke();
  fill(c1);
  rect(0, 0, 150, 300);
  fill(c2);
  rect(150, 0, 150, 300);
}
*/

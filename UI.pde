class UI {
  int points;
  int shopDelay;
  int shopItemDelay;
  int saveDelay;
  int loadDelay;
  boolean selectingLoadGame=false;
  boolean shopOpen=false;
  JSONArray shop;
  PImage pointsI;
  PImage shopI;
  PImage saveI;
  PImage loadI;
  
  UI(){
    points=1000;
    shopDelay=0;
    shopItemDelay=0;
    saveDelay=0;
    pointsI=loadImage("icons/topbar/points.png");
    shopI=loadImage("icons/topbar/shop.png");
    saveI=loadImage("icons/topbar/save.png");
    loadI=loadImage("icons/topbar/load.png");
    shop = loadJSONArray("shop.json");
  }
  
  void draw(){
    addPoints();
    //Top bar
    //println("delay: " + shopDelay + " - ShopOpen: " + shopOpen);
    if(shopDelay>0){
      shopDelay--;
    }
    if(saveDelay>0){
      saveDelay--;
    }
    if(loadDelay>0 && selectingLoadGame==false){
      loadDelay--;
    }
    fill(0);
    rect(0,0,width,30);
    fill(255);
    textSize(20);
    text(points,5,25);
    image(pointsI,textWidth("0000")+7,5,20,20);
    image(shopI,textWidth("0000")+34,5,20,20);
    if(buttonPressed(int(textWidth("0000")+34),0,20,25) && shopDelay==0){
      shopOpen=!shopOpen;
      shopDelay=10;
    }
    if(shopOpen){
      fill(51,51,51,175);
      rect(0,30,width/2,height-30);
      translate(0,0,1);
      drawShop();
      translate(0,0,-1);
    }
    image(saveI,width-52,5,20,20);
    if(buttonPressed(width-52,0,20,25) && saveDelay==0){
      saveDelay=10;
      saveGame();
    }
    image(loadI,width-25,5,20,20);
    if(buttonPressed(width-25,0,20,25) && loadDelay==0){
      loadDelay=10;
      selectingLoadGame=true;
      loadGame();
    }
  }
  
  void drawShop(){
    if(shopItemDelay>0){
      shopItemDelay--;
    }
    int x=40,y=40;
    for(int i=0;i<shop.size();i++){
      JSONObject item=shop.getJSONObject(i);
      String name = item.getString("name");
      PImage image;
      image = loadImage("icons/store/" + name + ".png");
      if(image==null){
        image=loadImage("icons/store/notAvailable.png");
      }
      image(image,x,y,100,100);
      fill(0);
      rect(x,y+100,100,20);
      fill(255);
      textSize(16);
      text(item.getString("displayName"),(x+50)-(textWidth(item.getString("displayName"))/2),y+118);
      if(buttonPressed(x,y,100,120) && shopItemDelay==0){
        if(item.getString("type").equals("special")){
          if(name.equals("grass")){
            placingGrass=true;
          }
        }
        points-=item.getInt("cost");
        shopItemDelay=10;
      }
      if(buttonHovered(x,y,100,120)){
        //print("ButtonHovered");
        translate(0,0,1);
        fill(0);
        rect(x+100,y,150,120);
        fill(255);
        text("Cost: " + item.getInt("cost"),x+105,y+18);
        text(item.getString("description"),x+105,y+36);
        translate(0,0,-1);
      }
      if(x+(125*i)>width/2){
        y+=145;
        x=40;
      }else{
        x+=125;
      }
  }
  }
  
  void addPoints(){
    //Grass
    if(frameCount%100==0){
      points+=int(t.numberGrass()/2);
    }
  }
  
  boolean buttonPressed(int x,int y,int w,int h){
    if(mouseX<x+w && mouseX>x && mouseY<y+h && mouseY>y && mousePressed){
      return true;
    }else{
      return false;
    }
  }
  
  boolean buttonHovered(int x,int y,int w,int h){
    if(mouseX<x+w && mouseX>x && mouseY<y+h && mouseY>y){
      return true;
    }else{
      return false;
    }
  }
}
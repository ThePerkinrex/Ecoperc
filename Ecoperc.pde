import java.util.Properties;
import java.util.UUID;

import ch.dieseite.colladaloader.*;
import ch.dieseite.colladaloader.asmbeans.*;
import ch.dieseite.colladaloader.coreproc.*; 
import ch.dieseite.colladaloader.wrappers.*;
import ch.dieseite.glemulator.*;

/*

Copyright © 2017 Perc Studios

||======================================================================================||
||                                          ECOPERC                                     ||
||======================================================================================||

*/

Terreno t;
Agua a;
UI ui;
ArrayList<Entity> entities;
int dist;
PVector camPos;
boolean placingGrass=false;

void setup(){
  fullScreen(P3D);
  entities=new ArrayList<Entity>();
  t=new Terreno(100);
  a=new Agua(t);
  ui=new UI();
  //entities.add(new SimpleTree(new PVector(0,0,0),this));
  //entities = append(entities,new SimpleTree(new PVector(0,0,0),this));
  //st=new SimpleTree(new PVector(0,0,0),this);
  dist=height-height/4;
  camPos=new PVector(width/2,height/2,100);
  ambientLight(200, 200, 200);
  noStroke();
  ui.draw();
}

void draw(){
  background(255);
  lights();
  
  lightSpecular(102, 102, 102);
  //stroke(#835215);
  //fill(131,82,21);
  //fill(#158323);
  translate(camPos.x,camPos.y,camPos.z);
  translate(-width/2,-dist,-10);
  //rotateX(PI);
  pointLight(131,82,21, 0,0,200);
  t.draw();
  a.draw();
  //st.draw();
  moveCam();
  //rotateX(-PI);
  translate(-camPos.x,-camPos.y,-camPos.z);
  translate(width/2,dist,10);
  if(camPos.z<-150){
  ui.draw();
  }
}


void moveCam(){
  if(keyPressed){
    if(key=='w'){
      camPos.add(0,2,0);
    }else if(key=='s'){
      camPos.add(0,-2,0);
    }else if(key=='a'){
      camPos.add(2,0,0);
    }else if(key=='d'){
      camPos.add(-2,0,0);
    }else if(key=='p'){
      save("screenshots/" + year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+"-screenshot.jpg");
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e<0){
    camPos.add(0,0,2);
  }else if(e>0){
    camPos.add(0,0,-2);
  }
}

void saveGame(){
  JSONObject save = new JSONObject();
  save.setInt("points",ui.points);
  //save.setJSONObject("terrain",t.toJSON());
  JSONArray ent = new JSONArray();
  for(Entity e:entities){
    ent.setJSONObject(entities.indexOf(e),e.toJSON());
  }
  save.setJSONArray("entities",ent);
  String dirName=UUID.randomUUID()+"-game/";
  saveJSONObject(save, "savegames/"+dirName+"main.json");
  saveJSONObject(t.toJSON(), "savegames/"+dirName+"terrain.json");
}

void loadGame(){
  println("LOADING");
  selectFolder("Select a game directory to load","loadJSONs");
}

void loadJSONs(File selection){
  ui.selectingLoadGame=false;
  if(selection==null){
    println("user cancelled or a error occured");
  }else{
    println("user selected " + selection.getAbsolutePath());
    
    JSONObject terrain = loadJSONObject(selection.getAbsolutePath() + "/terrain.json");
    JSONObject main = loadJSONObject(selection.getAbsolutePath() + "/main.json");
    
    if(terrain!=null && main!=null){
      t.loadJSON(terrain);
      
      //Loading the main.json
      
      ui.points = main.getInt("points");
      
      JSONArray ent = main.getJSONArray("entities");
      for(int i=0;i<ent.size();i++){
        entities.get(i).loadJSON(ent.getJSONObject(i));
      }
    }
  }
}
class Terreno{
  
  float[][] alturas;
  color[][] colores;
  //int[][] type;
  int size;
  
  Terreno(int big){
    size=big;
    alturas = new float[size][size];
    colores = new color[size][size];
    for(int i=0;i<size;i++){
      for(int j=0;j<size;j++){
        alturas[j][i] = noise(j*0.1,i*0.1)*150;
        color toadd;
        if(alturas[j][i]>100){
          toadd=color(245);
        }else{
          toadd=color(131,82,21);
        }
        colores[j][i] = color(noise(j*0.2,i*0.2)*10+red(toadd) ,noise(j*0.2,i*0.2)*10+green(toadd),noise(j*0.2,i*0.2)*10+blue(toadd));
        //println(alturas[j][i]);
      }
    }
  }
  
  void draw(){
    beginShape(TRIANGLE);
    for(int y=0;y<size-1;y++){
      for(int x=0;x<size-1;x++){
        fill(colores[x][y]);
        vertex(x*10,y*10,alturas[x][y]);
        vertex((x+1)*10,y*10,alturas[x+1][y]);
        vertex(x*10,(y+1)*10,alturas[x][y+1]);
        fill(colores[x][y+1]);
        vertex(x*10,(y+1)*10,alturas[x][y+1]);
        vertex((x+1)*10,y*10,alturas[x+1][y]);
        vertex((x+1)*10,(y+1)*10,alturas[x+1][y+1]);
      }
    }
    endShape();
    if(placingGrass && mousePressed){
      placeGrass(int(map(mouseX,0,width,0,size*10)), int(map(mouseY,0,height,0,size*10)));
      placingGrass=false;
    }
  }
  
  int numberGrass(){
    int r=0;
    for(int y=0;y<size-1;y++){
      for(int x=0;x<size-1;x++){
        if(colores[x][y]==color(37,167,38)){
          r++;
        }
      }
    }
    return r;
  }
  
  void placeGrass(int x, int y){
    println("placedGrass");
    colores[int(x/10)][int(y/10)]=color(37,167,38);
    colores[int(x/10)+1][int(y/10)]=color(37,167,38);
    colores[int(x/10)-1][int(y/10)]=color(37,167,38);
    colores[int(x/10)][int(y/10)+1]=color(37,167,38);
    colores[int(x/10)][int(y/10)-1]=color(37,167,38);
  }
  
  void loadJSON(JSONObject terrO){
    JSONArray hs = terrO.getJSONArray("heights");
    for(int i=0;i<hs.size();i++){
      JSONArray hss = hs.getJSONArray(i);
      for(int j=0;j<hss.size();j++){
        alturas[i][j]=hss.getFloat(j);
      }
    }
    JSONArray cs = terrO.getJSONArray("colors");
    for(int i=0;i<cs.size();i++){
      JSONArray css = cs.getJSONArray(i);
      for(int j=0;j<css.size();j++){
        JSONObject clr = css.getJSONObject(j);
        colores[i][j]= color(clr.getInt("red"),clr.getInt("green"),clr.getInt("blue"));
      }
    }
  }
  
  JSONObject toJSON(){
    JSONObject r = new JSONObject();
    JSONArray firstArr = new JSONArray();
    int i=0;
    for(float arr[]:alturas){
      JSONArray secondArr = new JSONArray();
      int j=0;
      for(float altura:arr){
        secondArr.setFloat(j,altura);
        j++;
      }
      firstArr.setJSONArray(i,secondArr);
      i++;
    }
    r.setJSONArray("heights",firstArr);
    firstArr = new JSONArray();
    i=0;
    for(color arr[]:colores){
      JSONArray secondArr = new JSONArray();
      int j=0;
      for(color altura:arr){
        JSONObject clr = new JSONObject();
        clr.setFloat("red",red(altura));
        clr.setFloat("green",green(altura));
        clr.setFloat("blue",blue(altura));
        secondArr.setJSONObject(j,clr);
        j++;
      }
      firstArr.setJSONArray(i,secondArr);
      i++;
    }
    r.setJSONArray("colors",firstArr);
    return r;
  }
  
}
class Agua{
  
  float[][] alturas;
  color[][] colores;
  //int[][] type;
  int size;
  float xoff;
  float yoff;
  
  Agua(Terreno t){
    size=t.size;
    alturas = new float[size][size];
    colores = new color[size][size];
    xoff=0;
    yoff=0;
    for(int i=0;i<size;i++){
      for(int j=0;j<size;j++){
        alturas[j][i] = noise(j*0.1,i*0.1)*40+50;
        color toadd;
        //if(alturas[j][i]>100){
        //  toadd=color(245);
        //}else{
        //  toadd=color(131,82,21);
        //}
        toadd=color(62,194,245,150);
        colores[j][i] = color(noise(j*0.2,i*0.2)*15+red(toadd) ,noise(j*0.2,i*0.2)*15+green(toadd),noise(j*0.2,i*0.2)*15+blue(toadd),noise(j*0.2,i*0.2)*10+alpha(toadd));
        //println(alturas[j][i]);
      }
    }
  }
  
  void draw(){
    yoff+=0.004;
    xoff+=0.004;
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
    for(int i=0;i<size;i++){
      
      for(int j=0;j<size;j++){
        
        alturas[j][i] = noise(j*0.1+xoff,i*0.1+yoff)*10+50;
        color toadd;
        toadd=color(62,194,245,150);
        colores[j][i] = color(noise(j*0.2,i*0.2)*10+red(toadd) ,noise(j*0.2,i*0.2)*10+green(toadd),noise(j*0.2,i*0.2)*10+blue(toadd),noise(j*0.2,i*0.2)*10+alpha(toadd));
      }
    }
  }
  
}
class Entity {
  ColladaModel model;
  PVector pos;
  String modelDir;
  PApplet sketch;
  UUID uuid;
  Entity(String name, PVector npos, PApplet sketch) {
    this.sketch = sketch;
    pos=npos.copy();
    uuid=UUID.randomUUID();
    Properties optionals = new Properties();
    optionals.setProperty("LinkingSchema", "Blender");
    modelDir="models/"+name+".dae";
    model = ColladaLoader.load(modelDir, sketch, optionals);
    model.scale(10);
  }

  void setPos(float x, float y, float z) {
    pos.set(x, y, z);
  }

  void draw() {
    translate(pos.x, pos.y, pos.z);
    model.draw();
    extendedDraw();
  }
  
  void extendedDraw(){
    //For overrinding
  }
  
  void loadJSON(JSONObject entity) {
    
    JSONArray position = entity.getJSONArray("pos");
    pos.set(position.getFloat(0),position.getFloat(1),position.getFloat(2));
    uuid = UUID.fromString(entity.getString("UUID"));
    
    Properties optionals = new Properties();
    optionals.setProperty("LinkingSchema", "Blender");
    modelDir=entity.getString("model");
    model = ColladaLoader.load(modelDir, sketch, optionals);
  }

  JSONObject toJSON() {
    JSONObject r=new JSONObject();
    JSONArray pos=new JSONArray();
    pos.setFloat(0, this.pos.x);
    pos.setFloat(1, this.pos.y);
    pos.setFloat(2, this.pos.z);
    r.setString("UUID", uuid.toString());
    r.setJSONArray("pos", pos);
    r.setString("model", modelDir);
    return r;
  }
}
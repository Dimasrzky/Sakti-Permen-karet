class IbuWarung {
  PImage ibu_warung;
  
  float x, y;
  float targetX, targetY;
  float rotation = 0;
  float scale = 1.0;
  
  String currentDialog = "";
  float dialogStartTime = 0;
  
  IbuWarung() {
    loadImages();
    x = width * 0.8;
    y = height * 0.7;
    targetX = x;
    targetY = y;
  }
  
  void loadImages() {
    boolean ENABLE_IMAGE_LOADING = true; // Ubah ke true jika file sudah ada
    
    if (ENABLE_IMAGE_LOADING) {
      ibu_warung = loadImage("data/Ibu warung.png");
      println("Ibu Warung: Image loaded successfully");
    } else {
      ibu_warung = null;
      println("Ibu Warung: Using fallback drawing (image loading disabled)");
    }
  }
  
  void renderDalamWarung(float time) {
    x = width * 0.7;
    y = height * 0.7;
    
    if (time < 6) {
      setDialog("Eh, Sakti. Lagi jalan-jalan? Mau beli apa nih?", time, 2, 5);
    } else if (time < 16) {
      setDialog("Permen karet? Bukannya lagi puasa?", time, 11, 15);
    } else if (time < 25) {
      setDialog("Oh ya? Kirain kamu gak puasa...", time, 20, 23);
    } else {
      setDialog("Anak-anak sekarang...", time, 40, 45);
    }
    
    drawCharacter();
    renderDialog();
  }
  
  void drawCharacter() {
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    scale(scale);
    
    x = lerp(x, targetX, 0.05);
    y = lerp(y, targetY, 0.05);
    
    if (ibu_warung != null) {
      imageMode(CENTER);
      image(ibu_warung, 0, 0, ibu_warung.width * 0.3, ibu_warung.height * 0.3);
    } else {
      drawIbuWarungCharacter();
    }
    
    popMatrix();
  }
  
  void drawIbuWarungCharacter() {
    fill(200, 255, 200);
    ellipse(0, 0, 65, 85);
    
    fill(255, 220, 177);
    ellipse(0, -50, 50, 50);
    
    fill(100, 50, 100);
    ellipse(0, -60, 55, 35);
    arc(0, -40, 60, 40, PI, TWO_PI);
    
    fill(255);
    ellipse(-8, -55, 8, 8);
    ellipse(8, -55, 8, 8);
    fill(0);
    ellipse(-8, -55, 4, 4);
    ellipse(8, -55, 4, 4);
    
    fill(180, 100, 100);
    ellipse(0, -45, 10, 5);
    
    fill(255, 220, 177);
    ellipse(-25, -10, 15, 40);
    ellipse(25, -10, 15, 40);
    
    fill(150, 100, 150);
    ellipse(0, 40, 70, 50);
    
    fill(139, 69, 19);
    ellipse(-15, 70, 20, 12);
    ellipse(15, 70, 20, 12);
    
    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(10);
    text("IMG", 0, 90);
  }
  
  void setDialog(String dialog, float currentTime, float startTime, float endTime) {
    if (currentTime >= startTime && currentTime <= endTime) {
      currentDialog = dialog;
    } else if (currentTime > endTime) {
      currentDialog = "";
    }
  }
  
  void renderDialog() {
    if (currentDialog.length() > 0) {
      fill(220, 255, 220, 200);
      rect(x - 200, y - 150, 400, 80, 10);
      
      fill(0, 100, 0);
      textAlign(CENTER);
      textSize(16);
      text(currentDialog, x, y - 110);
    }
  }
  
  void moveTo(float newX, float newY) {
    targetX = newX;
    targetY = newY;
  }
  
  void setRotation(float newRotation) {
    rotation = newRotation;
  }
  
  void setScale(float newScale) {
    scale = newScale;
  }
}

class Hafi {
  PImage hafi_jalan, hafi_kaget, hafi_memuju_di_masjid;
  PImage hafi_mengajak_ke_masjid, hafi_nasihat, hafi_nasihat_sambil_tertawa;
  PImage hafi_negur;
  
  float x, y;
  float targetX, targetY;
  float rotation = 0;
  float scale = 1.0;
  
  String currentDialog = "";
  float dialogStartTime = 0;
  
  Hafi() {
    loadImages();
    x = width * 0.6;
    y = height * 0.6;
    targetX = x;
    targetY = y;
  }
  
  void loadImages() {
    boolean ENABLE_IMAGE_LOADING = true; // Ubah ke true jika file sudah ada
    
    if (ENABLE_IMAGE_LOADING) {
      hafi_jalan = loadImage("data/Hafi - jalan.png");
      hafi_kaget = loadImage("data/Hafi - kaget.png");
      hafi_memuju_di_masjid = loadImage("data/Hafi - memuji di masjid.png");
      hafi_mengajak_ke_masjid = loadImage("data/Hafi - mengajak ke masjid.png");
      hafi_nasihat = loadImage("data/Hafi - nasihat.png");
      hafi_nasihat_sambil_tertawa = loadImage("data/Hafi - nasihat sambil tertawa.png");
      hafi_negur = loadImage("data/Hafi - negur.png");
      
      println("Hafi: All images loaded successfully");
    } else {
      hafi_jalan = null;
      hafi_kaget = null;
      hafi_memuju_di_masjid = null;
      hafi_mengajak_ke_masjid = null;
      hafi_nasihat = null;
      hafi_nasihat_sambil_tertawa = null;
      hafi_negur = null;
      
      println("Hafi: Using fallback drawing (image loading disabled)");
    }
  }
  
  void renderBelakangRumah(float time) {
    PImage currentImage;
    
    if (time < 16) {
      currentImage = hafi_jalan;
      x = lerp(-1750, width * 0.8, time / 20.0);
      y = height * 0.6;
    } else if (time < 28) {
      currentImage = hafi_kaget;
      x = width * 0.4;
      y = height * 0.6;
      setDialog("Saktiii! Kamu ngapain?!", time, 16, 20);
    } else if (time < 35) {
      currentImage = hafi_nasihat;
      x = width * 0.6;
      y = height * 0.6;
      setDialog("Sakti, walaupun nggak ditelan, ngunyah permen karet bisa membatalkan puasa loh.", time, 29, 33);
    } else if (time < 53) {
      currentImage = hafi_nasihat;
      setDialog("Sakti... semua orang bisa salah. Yang penting kamu belajar dari itu.", time, 39, 42);
    } else {
      currentImage = hafi_nasihat_sambil_tertawa;
      setDialog("Gak apa-apa, Sak. Kita juga pernah salah. Yang penting sadar dan berubah.", time, 50, 58);
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderPerjalanan(float time) {
    PImage currentImage = hafi_jalan;
    
    x = lerp(width * 0.5, width * 0.8, time / 60.0);
    y = height * 0.6;
    
    if (time < 30) {
      setDialog("Yuk, kita ke masjid bareng. Azan udah mulai tuh.", time, 20, 23);
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderTempatWudhu(float time) {
    PImage currentImage = hafi_jalan;
    
    x = width * 0.5;
    y = height * 0.6;
    
    y = height * 0.6 + sin(time * 1.5) * 8;
    
    if (time < 30) {
      setDialog("Ilmu itu harus disampaikan dengan kasih sayang, Sak.", time, 9, 14);
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderDalamMasjid(float time) {
    PImage currentImage = hafi_memuju_di_masjid;
    
    x = width * 0.4;
    y = height * 0.7;
    
    if (time > 30) {
      y = height * 0.8;
      scale = 0.8;
    }
    
    drawCharacter(currentImage);
  }
  
  void drawCharacter(PImage img) {
      pushMatrix();
      translate(x, y);
      rotate(rotation);
      scale(scale);
      
      x = lerp(x, targetX, 0.05);
      y = lerp(y, targetY, 0.05);
      
      if (img != null) {
        imageMode(CENTER);
        image(img, 0, 0, img.width * 1.3, img.height * 1.3);
      } else {
        drawHafiCharacter();
      }
      
      popMatrix();
  }
  
  void drawHafiCharacter() {
    fill(255, 240, 200);
    ellipse(0, 0, 60, 80);
    
    fill(255, 220, 177);
    ellipse(0, -50, 50, 50);
    
    fill(50, 50, 50);
    ellipse(0, -65, 35, 20);
    
    fill(30, 20, 10);
    arc(0, -55, 45, 25, 0, PI);
    
    fill(255);
    ellipse(-8, -55, 8, 8);
    ellipse(8, -55, 8, 8);
    fill(0);
    ellipse(-8, -55, 4, 4);
    ellipse(8, -55, 4, 4);
    
    fill(200, 100, 100);
    arc(0, -45, 10, 6, 0, PI);
    
    fill(255, 220, 177);
    ellipse(-25, -10, 15, 40);
    ellipse(25, -10, 15, 40);
    
    fill(80, 80, 80);
    ellipse(-15, 40, 18, 50);
    ellipse(15, 40, 18, 50);
    
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
        
        // Teks dialog
        fill(0);
        textAlign(CENTER);
        textSize(16);
        text(currentDialog, x, y - 420);
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

class Dimas {
  PImage dimas_curiga, dimas_jalan, dimas_kaget;
  PImage dimas_menasihat_di_masjid, dimas_menjelaskan_di_jalan;
  PImage dimas_menjelaskan, dimas_nasihat;
  
  float x, y;
  float targetX, targetY;
  float rotation = 0;
  float scale = 1.0;
  
  String currentDialog = "";
  float dialogStartTime = 0;
  
  Dimas() {
    loadImages();
    x = width * 0.7;
    y = height * 0.6;
    targetX = x;
    targetY = y;
  }
  
  void loadImages() {
    boolean ENABLE_IMAGE_LOADING = true; // Ubah ke true jika file sudah ada
    
    if (ENABLE_IMAGE_LOADING) {
      dimas_curiga = loadImage("data/Dimas - curiga.png");
      dimas_jalan = loadImage("data/Dimas - jalan.png");
      dimas_kaget = loadImage("data/Dimas - kaget.png");
      dimas_menasihat_di_masjid = loadImage("data/Dimas - menasihat di masjid.png");
      dimas_menjelaskan_di_jalan = loadImage("data/Dimas - menjelaskan di jalan.png");
      dimas_menjelaskan = loadImage("data/Dimas - menjelaskan.png");
      dimas_nasihat = loadImage("data/Dimas - nasihat.png");
      
      println("Dimas: All images loaded successfully");
    } else {
      dimas_curiga = null;
      dimas_jalan = null;
      dimas_kaget = null;
      dimas_menasihat_di_masjid = null;
      dimas_menjelaskan_di_jalan = null;
      dimas_menjelaskan = null;
      dimas_nasihat = null;
      
      println("Dimas: Using fallback drawing (image loading disabled)");
    }
  }
  
  void renderBelakangRumah(float time) {
    PImage currentImage;
    
    if (time < 16) {
      currentImage = dimas_jalan;
      x = lerp(-1250, width * 0.8, time / 20.0);
      y = height * 0.6;
      
    } else if (time < 22) {
      currentImage = dimas_kaget;
      x = width * 0.5;
      y = height * 0.6;
      //setDialog("Kamu ngunyah permen ya? Lagi puasa nggak?", time, 15, 20);
      
    } else if (time < 30) {
      currentImage = dimas_curiga;
      x = width * 0.5;
      y = height * 0.6;
      setDialog("Kamu ngunyah permen ya? HAYOOO", time, 23, 26);
      
    } else if (time < 33) {
      currentImage = dimas_jalan;
      x = width * 0.5;
      y = height * 0.6;
      
    } else if (time < 43) {
      currentImage = dimas_nasihat;
      x = width * 0.5;
      y = height * 0.6;
      setDialog("Iya, karena itu termasuk aktivitas makan dan nggak sesuai dengan makna puasa.", time, 33, 35);
      
    } else {
      currentImage = dimas_menjelaskan;
      x = width * 0.5;
      y = height * 0.6;
      setDialog("Ibadah itu bukan tentang kelihatan sempurna, tapi niat dan usaha untuk terus jadi lebih baik.", time, 44, 47);
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }

  
  void renderPerjalanan(float time) {
    PImage currentImage = dimas_jalan;
    
    x = lerp(width * 0.7, width * 0.9, time / 60.0);
    y = height * 0.6;
    
    if (time < 20) {
      setDialog("Betul banget. Puasa ngajarin kita disiplin, jujur sama diri sendiri, dan tanggung jawab.", time, 10, 15);
    } else if (time < 40) {
      currentImage = dimas_jalan;
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderTempatWudhu(float time) {
    PImage currentImage = dimas_jalan;
    
    x = width * 0.6;
    y = height * 0.6;
    
    if (time > 15) {
      x = width * 0.7;
      y = height * 0.6;
      currentImage = dimas_menasihat_di_masjid;
      setDialog("Yang penting kamu udah berubah. Itu keren banget menurutku.", time, 16, 20);
    } else if (time > 20) {
      currentImage = dimas_jalan;
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderDalamMasjid(float time) {
    PImage currentImage = dimas_nasihat;
    
    x = width * 0.2;
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
    
    // Mirror ke kanan (flip horizontal) untuk dimas_menasihat_di_masjid setelah 14 detik
    if (img == dimas_menasihat_di_masjid) {
        scale(-1, 1); // Mirror horizontal
    }
    
    x = lerp(x, targetX, 0.05);
    y = lerp(y, targetY, 0.05);
    
    if (img != null) {
      imageMode(CENTER);
      image(img, 0, 0, img.width * 0.8, img.height * 0.8);
    } else {
      drawDimasCharacter();
    }
    
    popMatrix();
}
  
  void drawDimasCharacter() {
    fill(200, 220, 255);
    ellipse(0, 0, 60, 80);
    
    fill(255, 220, 177);
    ellipse(0, -50, 50, 50);
    
    fill(40, 25, 15);
    ellipse(0, -60, 45, 30);
    
    fill(255);
    ellipse(-8, -55, 8, 8);
    ellipse(8, -55, 8, 8);
    fill(0);
    ellipse(-8, -55, 4, 4);
    ellipse(8, -55, 4, 4);
    
    noFill();
    stroke(0);
    strokeWeight(2);
    ellipse(-8, -55, 12, 12);
    ellipse(8, -55, 12, 12);
    line(-2, -55, 2, -55);
    noStroke();
    
    fill(100, 50, 0);
    ellipse(0, -45, 8, 5);
    
    fill(255, 220, 177);
    ellipse(-25, -10, 15, 40);
    ellipse(25, -10, 15, 40);
    
    fill(50, 50, 100);
    ellipse(-15, 40, 18, 50);
    ellipse(15, 40, 18, 50);
    
    fill(0);
    ellipse(-15, 70, 22, 14);
    ellipse(15, 70, 22, 14);
    
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
          
          // Dialog naik di scene tertentu
          if (currentScene == 4) {
              text(currentDialog, x, y - 450); // Naik 100 pixel
          } else {
              text(currentDialog, x, y - 210); // Posisi normal
          }
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

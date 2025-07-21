class Sakti {
  PImage sakti_bersalah, sakti_capek, sakti_ketahuan_makan;
  PImage sakti_ketakutan, sakti_makan_permen, sakti_masih_kepikiran;
  PImage sakti_memilih, sakti_menjawab, sakti_merasa_bersalah;
  PImage sakti_minta_maaf, sakti_mulai_serius, sakti_tertawa;
  
  float x, y;
  float targetX, targetY;
  float rotation = 0;
  float scale = 1.0;
  
  String currentDialog = "";
  float dialogStartTime = 0;
  boolean faceRight = false;
  
  Sakti() {
    loadImages();
    x = width * 0.3;
    y = height * 0.6;
    targetX = x;
    targetY = y;
  }
  
  void loadImages() {
    // Set ENABLE_IMAGE_LOADING = true jika file gambar sudah tersedia
    boolean ENABLE_IMAGE_LOADING = true; // Ubah ke true jika file sudah ada
    
    if (ENABLE_IMAGE_LOADING) {
      String[] imageFiles = {
        "Sakti - bersalah.png",
        "Sakti - capek.png", 
        "Sakti - ketahuan makan.png",
        "Sakti - ketakutan.png",
        "Sakti - makan permen.png",
        "Sakti - masih kepikiran.png",
        "Sakti - memilih.png",
        "Sakti - menjawab.png",
        "Sakti - merasa bersalah.png",
        "Sakti - minta maaf.png",
        "Sakti - mulai serius.png",
        "Sakti - tertawa.png"
      };
      
      PImage[] images = new PImage[imageFiles.length];
      
      for (int i = 0; i < imageFiles.length; i++) {
        images[i] = loadImage(imageFiles[i]);
      }
      
      sakti_bersalah = images[0];
      sakti_capek = images[1];
      sakti_ketahuan_makan = images[2];
      sakti_ketakutan = images[3];
      sakti_makan_permen = images[4];
      sakti_masih_kepikiran = images[5];
      sakti_memilih = images[6];
      sakti_menjawab = images[7];
      sakti_merasa_bersalah = images[8];
      sakti_minta_maaf = images[9];
      sakti_mulai_serius = images[10];
      sakti_tertawa = images[11];
      
      println("Sakti: All images loaded successfully");
    } else {
      // Set semua ke null untuk menggunakan fallback drawing
      sakti_bersalah = null;
      sakti_capek = null;
      sakti_ketahuan_makan = null;
      sakti_ketakutan = null;
      sakti_makan_permen = null;
      sakti_masih_kepikiran = null;
      sakti_memilih = null;
      sakti_menjawab = null;
      sakti_merasa_bersalah = null;
      sakti_minta_maaf = null;
      sakti_mulai_serius = null;
      sakti_tertawa = null;
      
      println("Sakti: Using fallback drawing (image loading disabled)");
    }
  }
  
  void setFacingRight(boolean right) {
    faceRight = right;
  }
  
  void renderDepanWarung(float time) {
    PImage currentImage;
    
    if (time < 10) {
      currentImage = sakti_capek;
      // Sakti berjalan dari kanan ke kiri menuju warung
      x = lerp(width - 100, width * 0.3, time / 10.0);
      setDialog("Hari ini panas banget ya... tenggorokan kering...", time, 0, 8);
    } else if (time < 20) {
      currentImage = sakti_memilih;
      x = width * 0.3; // Posisi di depan warung
      setDialog("Cuma ngunyah permen karet doang, kayaknya nggak masalah...", time, 10, 18);
    } else {
      currentImage = sakti_memilih;
      setDialog("Hmm... beli ah.", time, 20, 25);
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderDalamWarung(float time) {
    PImage currentImage;
    
    if (time < 14) {
      currentImage = sakti_memilih;
      sakti.setFacingRight(true);
      x = width * 0.4;
      y = height * 0.6;
      setDialog("Ano... ini bu, satu bungkus permen karet ya.", time, 6, 10);
    } else if (time < 25) {
      currentImage = sakti_bersalah;
      sakti.setFacingRight(false);
      x = width * 0.4;
      y = height * 0.6;
      setDialog("Eh... anu... buat adik saya kok, bu.", time, 15, 20);
    } else if (time < 30) {
      currentImage = sakti_tertawa;
      sakti.setFacingRight(false);
      x = width * 0.4;
      y = height * 0.6;
      setDialog("HEHEHE...iya bu", time, 25, 28);
    } else {
      currentImage = sakti_bersalah;
      sakti.setFacingRight(false); // Menghadap kiri (keluar)
      
      // Sakti jalan ke kiri (keluar dari warung)
      x = lerp(width * 0.4, width * 0.1, (time - 30) / 10.0); 
      y = height * 0.6;
      
      setDialog("Te-terima kasih ya bu", time, 33, 37);
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderBelakangRumah(float time) {
    PImage currentImage;
    
    if (time < 10) {
      currentImage = sakti_makan_permen;
      sakti.setFacingRight(false);
      x = width * 0.8;
      y = height * 0.7;
      setDialog("Seger banget... nggak makan, cuma ngunyah doang. Nggak batal dong harusnya...", time, 3, 6);
    } else if (time < 20) {
      currentImage = sakti_ketahuan_makan;
      x = width * 0.8;
      y = height * 0.7;
    } else if (time < 25) {
      currentImage = sakti_ketakutan;
      x = width * 0.8;
      y = height * 0.7;
      setDialog("Eh... anu...", time, 20, 22);
    } else if (time < 35) {
      currentImage = sakti_menjawab;
      x = width * 0.8;
      y = height * 0.7;
      setDialog("Iya sih... cuma ini doang kok. Nggak ditelan!", time, 26, 28);
    } else if (time < 40) {
      currentImage = sakti_merasa_bersalah;
      x = width * 0.8;
      y = height * 0.7;
      setDialog("Waduh... aku kira nggak masalah... Aku... aku malah bilang buat adikku lagi...", time, 36, 39);
    } else if (time < 56) {
      currentImage = sakti_minta_maaf;
      x = width * 0.8;
      y = height * 0.7;
      setDialog("Iya... makasih udah ngingetin. Aku malu banget sebenarnya.", time, 48, 51);
    } else {
      currentImage = sakti_tertawa;
      x = width * 0.8;
      y = height * 0.7;
      sakti.setFacingRight(true);
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderPerjalanan(float time) {
    PImage currentImage = sakti_masih_kepikiran;
    
    x = lerp(width * 0.3, width * 0.7, time / 60.0);
    y = height * 0.6;
    
    if (time < 23) {
      setDialog("Aku jadi mikir... ternyata puasa itu lebih dalam dari sekadar nahan lapar ya.", time, 5, 8);
    } else if (time < 40) {
      currentImage = sakti_mulai_serius;
      setDialog("Siap. Mulai sekarang aku mau serius belajar puasa yang benar.", time, 23, 26);
    }
    
    drawCharacter(currentImage);
    renderDialog();
  }
  
  void renderTempatWudhu(float time) {
    PImage currentImage = sakti_tertawa;
    
    x = width * 0.75;
    y = height * 0.6;
    
    if (time < 15) {
      setDialog("Terima kasih ya udah nggak marah dan malah ngajarin aku...", time, 3, 8);
      drawCharacter(currentImage);
    } 
    
    renderDialog();
  }
  
  void renderDalamMasjid(float time) {
    PImage currentImage = sakti_mulai_serius;
    
    x = width * 0.5;
    y = height * 0.7;
    
    // Use time parameter for prayer position
    if (time > 30) {
      y = height * 0.8; // Sujud position
    }
    
    drawCharacter(currentImage);
  }
  
  void drawCharacter(PImage img) {
      pushMatrix();
      translate(x, y);
      rotate(rotation);
      scale(scale);
      
      // Menghadap kiri hanya di scene tertentu
      if (currentScene == 5) { // Scene 2 dan 4
          scale(-1, 1); // Balik horizontal untuk menghadap kiri
      }
      
      x = lerp(x, targetX, 0.05);
      y = lerp(y, targetY, 0.05);
      
      if (img != null) {
        imageMode(CENTER);
        image(img, 0, 0, img.width * 0.7, img.height * 0.7);
      } else {
        drawSaktiCharacter();
      }
      
      popMatrix();
  }
  
  void drawSaktiCharacter() {
    fill(220, 220, 220);
    ellipse(0, 0, 60, 80);
    
    fill(255, 220, 177);
    ellipse(0, -50, 50, 50);
    
    fill(50, 30, 20);
    ellipse(0, -60, 45, 30);
    
    fill(255);
    ellipse(-8, -55, 8, 8);
    ellipse(8, -55, 8, 8);
    fill(0);
    ellipse(-8, -55, 4, 4);
    ellipse(8, -55, 4, 4);
    
    fill(200, 100, 100);
    ellipse(0, -45, 10, 5);
    
    fill(255, 220, 177);
    ellipse(-25, -10, 15, 40);
    ellipse(25, -10, 15, 40);
    
    fill(100, 100, 200);
    ellipse(-15, 40, 18, 45);
    ellipse(15, 40, 18, 45);
    
    fill(139, 69, 19);
    ellipse(-15, 65, 20, 12);
    ellipse(15, 65, 20, 12);
    
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
          if (currentScene == 5 || currentScene == 4) {
              text(currentDialog, x, y - 450); // Naik 100 pixel
          } else {
              text(currentDialog, x, y - 200); // Posisi normal
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

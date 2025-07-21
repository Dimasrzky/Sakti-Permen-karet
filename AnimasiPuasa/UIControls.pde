class UIControls {
  float playPauseX, playPauseY, playPauseW, playPauseH;
  float nextSceneX, nextSceneY, nextSceneW, nextSceneH;
  float resetX, resetY, resetW, resetH;
  float progressBarX, progressBarY, progressBarW, progressBarH;
  
  UIControls() {
    setupButtonPositions();
  }
  
  void setupButtonPositions() {
    float panelY = height - 120; // Lebih tinggi untuk resolusi 1920x1080
    
    playPauseX = 80;
    playPauseY = panelY;
    playPauseW = 120;
    playPauseH = 50;
    
    nextSceneX = 220;
    nextSceneY = panelY;
    nextSceneW = 140;
    nextSceneH = 50;
    
    resetX = 380;
    resetY = panelY;
    resetW = 120;
    resetH = 50;
    
    progressBarX = 550;
    progressBarY = panelY + 15;
    progressBarW = 600;
    progressBarH = 25;
  }
  
  void render() {
    fill(0, 0, 0, 150);
    rect(0, height - 140, width, 140); // Panel lebih besar
    
    drawButton(playPauseX, playPauseY, playPauseW, playPauseH, 
               animationPlaying ? "PAUSE" : "PLAY", color(100, 200, 100));
    
    drawButton(nextSceneX, nextSceneY, nextSceneW, nextSceneH, 
               "NEXT", color(100, 150, 200));
    
    drawButton(resetX, resetY, resetW, resetH, 
               "RESET", color(200, 100, 100));
    
    renderProgressBar();
    
  }
  
  void drawButton(float x, float y, float w, float h, String label, color buttonColor) {
    fill(buttonColor);
    rect(x, y, w, h, 5);
    
    stroke(255);
    strokeWeight(2);
    noFill();
    rect(x, y, w, h, 5);
    noStroke();
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(label, x + w/2, y + h/2);
  }
  
  void renderProgressBar() {
    fill(50);
    rect(progressBarX, progressBarY, progressBarW, progressBarH, 10);
    
    float sceneProgress = 0;
    int totalDuration = scenes.getSceneDuration(currentScene);
    
    if (totalDuration > 0) {
      float elapsedTime = (millis() - sceneStartTime) / 1000.0;
      sceneProgress = constrain(elapsedTime / totalDuration, 0, 1);
    }
    
    fill(100, 200, 100);
    rect(progressBarX, progressBarY, progressBarW * sceneProgress, progressBarH, 10);
    
    stroke(255);
    strokeWeight(1);
    noFill();
    rect(progressBarX, progressBarY, progressBarW, progressBarH, 10);
    noStroke();
    
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(12);
    text(int(sceneProgress * 100) + "%", progressBarX + progressBarW + 10, progressBarY + progressBarH/2);
  }
  
  void showSceneInfo(int sceneNumber, float elapsedTime) {
    fill(0, 0, 0, 150);
    rect(width - 300, 50, 280, 120, 10);
    
    fill(255);
    textAlign(LEFT);
    textSize(16);
    text("Scene " + sceneNumber + ": " + scenes.getSceneName(sceneNumber), width - 290, 80);
    
    textSize(14);
    text("Waktu: " + nf(elapsedTime, 0, 1) + "s / " + scenes.getSceneDuration(sceneNumber) + "s", 
         width - 290, 105);
    
    text("Status: " + (animationPlaying ? "Playing" : "Paused"), width - 290, 125);
    
    textSize(12);
    text("Kontrol:", width - 290, 145);
    text("SPACE - Play/Pause", width - 290, 160);
    text("N - Next Scene", width - 290, 175);
    text("R - Reset", width - 290, 190);
  }
  
  void handleMousePress(int mouseX, int mouseY) {
    if (mouseX >= playPauseX && mouseX <= playPauseX + playPauseW &&
        mouseY >= playPauseY && mouseY <= playPauseY + playPauseH) {
      animationPlaying = !animationPlaying;
      println(animationPlaying ? "Animation resumed" : "Animation paused");
    }
    else if (mouseX >= nextSceneX && mouseX <= nextSceneX + nextSceneW &&
             mouseY >= nextSceneY && mouseY <= nextSceneY + nextSceneH) {
      if (currentScene < 6) {
        currentScene++;
        sceneStartTime = millis();
        println("Moved to scene " + currentScene);
      }
    }
    else if (mouseX >= resetX && mouseX <= resetX + resetW &&
             mouseY >= resetY && mouseY <= resetY + resetH) {
      currentScene = 1;
      sceneStartTime = millis();
      animationPlaying = true;
      println("Animation reset to scene 1");
    }
    else if (mouseX >= progressBarX && mouseX <= progressBarX + progressBarW &&
             mouseY >= progressBarY && mouseY <= progressBarY + progressBarH) {
      float clickProgress = (mouseX - progressBarX) / progressBarW;
      int sceneDuration = scenes.getSceneDuration(currentScene);
      float newTime = clickProgress * sceneDuration * 1000;
      sceneStartTime = millis() - newTime;
      println("Seeked to " + (newTime/1000.0) + " seconds in current scene");
    }
  }
}

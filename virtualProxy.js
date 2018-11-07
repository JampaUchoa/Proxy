class Image {
  constructor(url) {
    this.url = url;
  }

  loadImage() {
    
  }

}

class ImageProxy {

  constructor(url) {
    this.url = url;
    this.loaded = false;
    this.image = null;
  }

  loadImage() {
    this.image = new Image(this.filename)
    if (!this.image.loaded) {
      this.image.loadImage();
    }
  }

}

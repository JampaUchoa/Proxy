class Image {
  constructor(url, id) {
    this.url = url;
    this.id = id;
  }

  loadImage() {
    document.getElementById(this.id).style.backgroundImage = "url("+this.url+")";
  }

}

class ImageProxy {

  constructor(url, id) {
    this.url = url;
    this.id = id;
    this.loaded = false;
    this.image = new Image(url, id);
  }

  loadImage() {
    if (!this.loaded) {
      console.log(this.image);
      image.image.loadImage();
      document.getElementById("beach").style.filter = "blur(0)";
      this.loaded = true;
    }
  }

}

image = new ImageProxy("./real.jpg", "beach");

document.getElementById("btn").addEventListener("click", image.loadImage, false);

import { Controller } from "@hotwired/stimulus"
import "fslightbox"

export default class extends Controller {

  connect() {
    refreshFsLightbox();
    let link = document.querySelector(".gallery-n-more-link")
    if (link) {
      link.onclick = () => { fsLightbox.open() }
    }
  }
  
  disconnect() {
    console.log("disconnected!");
  }
}
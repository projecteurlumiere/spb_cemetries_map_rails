import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    refreshFsLightbox();
    let link = document.querySelector(".gallery-n-more-link")
    if (link) {
      link.onclick = () => { fsLightbox.open() }
    }
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    coordinates: String,
    id: Number,
  }
  
  connect() {
    let parsedCoordinates;
    if (this.coordinatesValue) {
      parsedCoordinates = JSON.parse(this.coordinatesValue);
    }
    
    console.log("i am about to dispatch the event");
    this.dispatch('connect', { detail: { coordinates: parsedCoordinates, id: this.idValue } })


  }

}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    coordinates: String,
  }
  
  connect() {
    console.log(this.coordinatesValue);
    let parsedCoordinates;
    if (this.coordinatesValue) {
      parsedCoordinates = JSON.parse(this.coordinatesValue);
    }
    
    console.log("i am about to dispatch the event");
    this.dispatch('connect', { detail: { coordinates: parsedCoordinates } })
    

    // if (this.coordinatesValue) {
    //   let parsedCoordinates = JSON.parse(this.coordinatesValue);
    //   L.polygon(parsedCoordinates).addTo(map);
    // }
    
    
    // console.log(`Hello World! I am\n`);
    // console.dir(this);

  }

  // dispatchClickEvent(e){
  //   dispatch
  // }
}

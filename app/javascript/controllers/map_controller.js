import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
import "leaflet-sidebar-v2"

export default class extends Controller {
  // static values = {
  //   coordinates: String,
  // }
  
  connect() {
    console.log("map controller starts connecting");
    this.map = L.map('map').setView([59.8965, 30.3264], 10);

    L.tileLayer(`https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.{ext}?api_key=1`, {
      minZoom: 10,
      attribution: '&copy; <a href="https://www.stadiamaps.com/" target="_blank">Stadia Maps</a> &copy; <a href="https://openmaptiles.org/" target="_blank">OpenMapTiles</a> &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      ext: 'png'
    }).addTo(this.map);

    this.sidebar = L.control.sidebar({
      container: 'sidebar', // the DOM container or #ID of a predefined sidebar container that should be used
      closeButton: true,    // whether t add a close button to the panes
      position: 'left',     // left or right
    }).addTo(this.map);
    
    this.sidebar.open('list-tab');
    
    console.log(`Hello World! I am\n`);
    console.dir(this);

    console.log('map controller has done its work')
  }

  drawPolygons(e) {
    if (e.detail.coordinates) {
      L.polygon(e.detail.coordinates).addTo(this.map);
      console.log('I have drawn a polygon!')
    }
  }

  toEntry(e) {
    this.sidebar.open('entry-info');
  }
}

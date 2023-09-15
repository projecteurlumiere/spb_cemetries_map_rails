import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
import "leaflet-sidebar-v2"

export default class extends Controller {
  // static values = {
  //   coordinates: String,
  // }
  
  connect() {
    this.polygons = {}
    this.map = L.map('map').setView([59.8965, 30.3264], 10);

    if (window.location.toString().includes("/cemeteries/")) {
      this.isShowRequest = true
      this.initialEntryId = document.getElementById('entry').getAttribute('data-cemetery-id-value')
    }
    else this.isShowRequest = false

    console.log(this.isShowRequest)

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

    console.log('map controller has done its work')
  }

  drawPolygon(e) {
    if (e.detail.coordinates) {
      let polygon = L.polygon(e.detail.coordinates, {cemetery_id: e.detail.id});
    
      this.polygons[e.detail.id] = polygon;
      polygon.addTo(this.map);

      polygon.addEventListener('click', () => {
        this.centerMap(polygon);
        this.sidebar.open('entry-info')
        Turbo.visit(`/cemeteries/${e.detail.id}`, { action: 'advance', frame: 'entry' }); // doesn't update URL despite action: advance- apparently, rails bug
      })

      if (this.isShowRequest === true && this.initialEntryId == e.detail.id) {
        this.centerMap(polygon)
        this.sidebar.open('entry-info')
      }

      console.log('I have drawn a polygon!')
    }
  }

  toEntry(e) {
    console.log(typeof e)
    console.log(e.target);
    console.log(e.target.getAttribute("data-cemetery-id-value"));

    let polygon = this.polygons[e.target.getAttribute("data-cemetery-id-value")];
    
    this.centerMap(polygon);

    this.sidebar.open('entry-info');
  }

  centerMap(polygon) {
    if (polygon) {
      this.map.flyTo(polygon.getCenter(), 14)
    }
  }

}

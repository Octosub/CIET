import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phototoggler"
export default class extends Controller {
static targets = [ "front", "back" ];

  connect() {
  }

  togglePhoto() {
    this.frontTarget.classList.toggle("d-none");
    this.backTarget.classList.toggle("d-none");
  }
}

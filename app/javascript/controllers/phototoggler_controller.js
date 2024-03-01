import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="phototoggler"
export default class extends Controller {
static targets = [ "front", "back" ];

  connect() {
    console.log("phototoggler connected", this.backTarget, this.frontTarget);
  }

  togglePhoto() {
    console.log("click", this.frontTarget, this.backTarget);
    this.frontTarget.classList.toggle("d-none");
    this.backTarget.classList.toggle("d-none");
  }
}

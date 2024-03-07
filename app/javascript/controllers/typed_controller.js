import { Controller } from "@hotwired/stimulus"
import Typed from 'typed.js';

// Connects to data-controller="typed"
export default class extends Controller {
  connect() {

    new Typed(this.element, {
      strings: ["Scanning ingredients...", "Checking for restrictions...", "Asking vegans for their opinion...", "Looking for deez nuts in your food...", "Jkjk", "WIFI seems to be pretty slow...", "BRB..."],
      typeSpeed: 75,
      loop: true,
    });
  }
}

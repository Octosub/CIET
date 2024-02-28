import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="extended-infos"
export default class extends Controller {
  static targets = [ "info" ];

  connect() {
    console.log("connected");
  }

  revealInfos(event) {
    event.currentTarget.nextElementSibling.classList.toggle("d-none");
    // console.log(this.infoTarget);
    // this.infoTarget.classList.toggle("d-none");
    // event.currentTarget.innerHTML = event.currentTarget.innerHTML === "v" ? ">" : "v";
    event.currentTarget.classList.toggle("rotated-element")
  }
}

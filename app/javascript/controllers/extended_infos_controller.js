import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="extended-infos"
export default class extends Controller {
  static targets = [ "info", "shover", "shrinker", "showup", "hider" ];

  connect() {
    // console.log("connected", this.infoTarget);
    console.log("extended infos controller initialized");
  }

  revealInfos(event) {
    // event.currentTarget.nextElementSibling.classList.toggle("d-none");
    // console.log(this.infoTarget);
    this.infoTarget.classList.toggle("d-none");
    // event.currentTarget.innerHTML = event.currentTarget.innerHTML === "v" ? ">" : "v";
    event.currentTarget.classList.toggle("rotated-element")
    this.shoverTarget.classList.toggle("column-shover")
    this.shrinkerTarget.classList.toggle("column-shrinker")
    this.showupTarget.classList.toggle("d-none")
    this.hiderTarget.classList.toggle("d-none")
  }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosubmit"
export default class extends Controller {
  static targets = [ "form", "hide", "show" ];

  connect() {
    console.log("autosubmit connected");
    console.log(this.formTarget, this.showTarget.innerHTML);

  }

  submitForm() {
    this.hideTarget.classList.toggle("d-none");
    this.showTarget.classList.remove("d-none");
    this.showTarget.classList.add("d-flex");
    this.formTarget.submit();
  }

  submitPicture() {
    console.log(this.formTarget);
    this.formTarget.submit();
  }
}

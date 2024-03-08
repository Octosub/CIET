import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosubmit"
export default class extends Controller {
  static targets = [ "form", "hide", "show", "show2" ];

  connect() {
  }

  submitForm() {
    this.hideTarget.classList.toggle("d-none");
    this.showTarget.classList.remove("d-none");
    // this.show2Target.classList.remove("d-none");
    this.showTarget.classList.add("d-flex");
    this.formTarget.submit();
  }

  submitPicture() {
    console.log(this.formTarget);
    this.formTarget.submit();
  }
}

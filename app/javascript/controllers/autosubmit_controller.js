import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosubmit"
export default class extends Controller {
  static targets = [ "form" ];

  connect() {
    console.log("autosubmit connected");
  }

  submitForm() {
    console.log(this.formTarget);
    this.formTarget.submit();
  }
}

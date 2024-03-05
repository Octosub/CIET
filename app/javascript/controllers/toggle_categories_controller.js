import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-categories"
export default class extends Controller {
static targets = [ "vegan", "vegetarian", "pescetarian", "dairy-free", "peanut-free" ]
preferences = "";

  connect() {
    console.log("toggle connected");
  }

  toggleVegan() {
    if (this.preferences.includes('vegan')) {
      this.preferences = this.preferences.replace(/ ?vegan/g, '');
    } else {
      this.preferences += (this.preferences ? ' vegan' : 'vegan');
    }
    
    console.log(this.preferences);
  }

  toggleVegetarian() {
    if (this.preferences.includes('vegetarian')) {
      this.preferences = this.preferences.replace(/ ?vegetarian/g, '');
    } else {
      this.preferences += (this.preferences ? ' vegetarian' : 'vegetarian');
    }
    console.log(this.preferences);
  }

  togglePescetarian() {
    console.log("Pescetarian");
  }
  toggleDairyFree() {
    console.log("DairyFree");
  }
  togglePeanutFree() {
    console.log("PeanutFree");
  }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fav-his-toggler"
export default class extends Controller {
  connect() {

    const favoritesTab = document.getElementById('favorites-tab');
    const historyTab = document.getElementById('history-tab');
    const favoritesContent = document.getElementById('favorites-content');
    const historyContent = document.getElementById('history-content');

    favoritesTab.addEventListener('click', function() {
      favoritesTab.classList.add('active');
      historyTab.classList.remove('active');
      favoritesContent.classList.remove('hidden');
      historyContent.classList.add('hidden');
    });

    historyTab.addEventListener('click', function() {
      historyTab.classList.add('active');
      favoritesTab.classList.remove('active');
      historyContent.classList.remove('hidden');
      favoritesContent.classList.add('hidden');
    });

  }
}

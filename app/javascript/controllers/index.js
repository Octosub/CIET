// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

document.addEventListener("DOMContentLoaded", function() {
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
});

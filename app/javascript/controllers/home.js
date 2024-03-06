const loadingText = document.getElementById('loading-text');
const loadingMessages = ["Loading", "Scanning", "Extracting"];

let index = 0;
const intervalId = setInterval(function() {
  loadingText.textContent = loadingMessages[index];
  index = (index + 1) % loadingMessages.length;
}, 2000);

window.addEventListener("load", function() {
  clearInterval(intervalId);
  loadingText.textContent = "Loaded!";
  loadingText.style.color = "green"; // Optionally change color
  setTimeout(function() {
   loadingText.style.display = "none"; // Optionally hide text after a delay
  }, 1000); // Change the delay as needed
});

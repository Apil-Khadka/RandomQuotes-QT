// Util.js

// Adjust the main layout font size and spacing based on the window dimensions.
function updateLayout(window, mainColumn) {
    var baseSize = Math.min(window.width, window.height) * 0.04;
    window.fontSize = baseSize;
    mainColumn.spacing = baseSize * 0.5;
}

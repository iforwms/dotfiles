// ==UserScript==
// @name         Mirror Video
// @namespace    https://iforwms.com/
// @version      0.1
// @description  Mirror all video elements on a page.
// @author       iforwms
// @match        http*://*/*
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

(function () {
  "use strict";

  var toggled = false;
  var videos = document.getElementsByTagName("video");

  if (!videos.length) {
    return;
  }

  function toggleMirror(e) {
    for (var i = 0; i < videos.length; i++) {
      if (toggled) {
        videos[i].style.transform = "scaleX(1)";
        e.target.style.backgroundColor = "#aaa";
      } else {
        videos[i].style.transform = "scaleX(-1)";
        e.target.style.backgroundColor = "red";
      }
    }
    toggled = !toggled;
  }

  var button = document.createElement("div");
  button.innerHTML = "MV";
  button.addEventListener("click", toggleMirror);
  button.style.cssText = `
    position: absolute;
    background-color: #aaa;
    display: flex;
    color: white;
    z-index: 99999;
    margin: 6px;
    top: 0;
    right: 0;
    height: 16px;
    width: 16px;
    align-items: center;
    justify-content: center;
    border-radius: 100%;
    cursor: pointer;
    font-size: 8px;
  `;
  document.body.appendChild(button);
})();

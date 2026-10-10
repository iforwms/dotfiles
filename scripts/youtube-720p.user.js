// ==UserScript==
// @name         YouTube: lock to 720p
// @namespace    youtube-720
// @version      1.0.0
// @description  Plays every YouTube video at 720p instead of Auto. Picking a quality yourself in the player is respected for that video.
// @match        *://www.youtube.com/*
// @match        *://m.youtube.com/*
// @match        *://www.youtube-nocookie.com/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(() => {
  'use strict';

  const TARGET = 'hd720';
  // YouTube's quality ids, lowest to highest.
  const ORDER = ['tiny', 'small', 'medium', 'large', 'hd720', 'hd1080', 'hd1440', 'hd2160', 'hd2880', 'highres'];

  // Player element -> id of the video whose quality we already set.
  // Keyed on the video id alone: picking a quality in the menu reloads the <video> element,
  // so keying on anything finer would undo the user's choice.
  const handled = new WeakMap();

  // In a Firefox content-script sandbox the player's API is only reachable through wrappedJSObject.
  const api = (el) => el.wrappedJSObject || el;

  // 720p if the video has it; otherwise the best quality below 720p, otherwise the lowest above it.
  function pick(levels) {
    const ranked = levels.filter((q) => ORDER.includes(q)).sort((a, b) => ORDER.indexOf(a) - ORDER.indexOf(b));
    if (ranked.includes(TARGET)) return TARGET;
    const below = ranked.filter((q) => ORDER.indexOf(q) < ORDER.indexOf(TARGET));
    return below.length ? below[below.length - 1] : ranked[0];
  }

  function apply(el) {
    const p = api(el);
    if (typeof p.getVideoData !== 'function' || typeof p.setPlaybackQualityRange !== 'function') return;
    if (el.classList.contains('ad-showing')) return;
    const id = p.getVideoData()?.video_id;
    if (!id || handled.get(el) === id) return;
    const q = pick(Array.from(p.getAvailableQualityLevels?.() || []));
    if (!q) return; // formats not known yet; the next media event retries
    p.setPlaybackQualityRange(q, q);
    handled.set(el, id);
    console.info(`[yt-720] ${id}: locked to ${q}`);
  }

  // Media events don't bubble, so listen during capture. timeupdate keeps retrying until
  // the formats are known and any pre-roll ad has finished.
  const onMedia = (e) => {
    const el = e.target.closest?.('.html5-video-player');
    if (el) apply(el);
  };
  for (const type of ['loadedmetadata', 'playing', 'timeupdate']) {
    document.addEventListener(type, onMedia, true);
  }
})();

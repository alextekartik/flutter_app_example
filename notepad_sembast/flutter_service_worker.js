'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/assets/packages/tekartik_app_roboto/fonts/Roboto/Roboto-Regular.ttf": "3e1af3ef546b9e6ecef9f3ba197bf7d2",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/LICENSE": "479b24fadbe8dbf33c8b1ad04ac8923a",
"/assets/AssetManifest.json": "e1961c0bec4a3f540c85ada3a529dcb1",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/FontManifest.json": "7be6663596f7f7e92f09b6d73eb425c3",
"/main.dart.js": "6c2032064c884ce7bfd5ec18c9f93cfe",
"/manifest.json": "8e064c3bcf0ecaeb0545f8ae28323222",
"/index.html": "c3c6e64cfe4cdfed3e7516455f730e68"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});

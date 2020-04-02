'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/assets/packages/tekartik_app_roboto/fonts/Roboto/Roboto-Regular.ttf": "3e1af3ef546b9e6ecef9f3ba197bf7d2",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/LICENSE": "ccace024b031a67c97882c54b5dfedda",
"/assets/AssetManifest.json": "e1961c0bec4a3f540c85ada3a529dcb1",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/FontManifest.json": "7be6663596f7f7e92f09b6d73eb425c3",
"/main.dart.js": "d3d11864aea0092e6fdb391055c30073",
"/manifest.json": "2c169f44db17f4accacb57edaaee1609",
"/index.html": "adbecb4f5a4a1331e54eef77e73a44ed"
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

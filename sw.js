const CACHE_NAME = 'orcamento-domestico-bi-forecast-v2';
const ASSETS = [
  './',
  './index.html',
  './manifest.webmanifest',
  './supabase-config.js',
  './supabase_schema.sql',
  './README.txt',
  './icon-192.png',
  './icon-512.png'
];
self.addEventListener('install', e => { e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(ASSETS))); self.skipWaiting(); });
self.addEventListener('activate', e => { e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k))))); self.clients.claim(); });
self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  e.respondWith(caches.match(e.request).then(cached => cached || fetch(e.request).then(resp => {
    const cloned = resp.clone();
    caches.open(CACHE_NAME).then(c => c.put(e.request, cloned));
    return resp;
  }).catch(() => caches.match('./index.html'))));
});

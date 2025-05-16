export async function register() {
  if ("serviceWorker" in navigator) {
    return await navigator.serviceWorker.register("/service-worker.js");
  } else {
    alert("Service Worker が未対応のブラウザです。");
  }
}
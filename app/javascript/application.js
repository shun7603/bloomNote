// app/javascript/home.js (こちらを使っている場合)
import "@hotwired/turbo-rails"
import "bootstrap"


// app/javascript/application.js など（Turbo読み込み後）

document.addEventListener("turbo:load", () => {
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("/service-worker.js").then(registration => {
      console.log("✅ Service Worker 登録完了:", registration);
    }).catch(error => {
      console.error("❌ Service Worker 登録失敗:", error);
    });
  }
});
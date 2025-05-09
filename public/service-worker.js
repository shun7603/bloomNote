// public/service-worker.js

self.addEventListener("push", function (event) {
  const data = event.data.json();

  const title = data.title || "BloomNote";
  const options = {
    body: data.body || data.message || "新しい通知があります。",
    icon: "/icons/notification-icon.png", // 任意のアイコン（無ければ削除でもOK）
    badge: "/icons/badge-icon.png"        // 任意（無ければ削除でもOK）
  };

  event.waitUntil(
    self.registration.showNotification(title, options)
  );
});
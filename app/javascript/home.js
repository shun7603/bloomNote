console.log("✅ home.js 読み込まれました");

// ルーティン表示切替
window.showRoutine = function(childId, childName) {
  document.querySelectorAll(".child-routine-section").forEach(el => el.style.display = "none");
  const section = document.getElementById(`routine-${childId}`);
  if (section) section.style.display = "block";

  const header = document.getElementById("child-name-header");
  if (header) header.textContent = `${childName}ちゃんのルーティン`;

  const routineDataElement = document.getElementById(`routine-data-${childId}`);
  const footer = document.getElementById(`task-footer-${childId}`);
  if (!routineDataElement || !footer) return;

  const routineData = JSON.parse(routineDataElement.dataset.routine);
  const now = new Date();
  const nowMinutes = now.getHours() * 60 + now.getMinutes();

  function timeToMinutes(timeStr) {
    if (!timeStr) return Infinity;
    const [hour, minute] = timeStr.split(":").map(Number);
    return (hour || 0) * 60 + (minute || 0);
  }

  let nextTask = "なし";
  for (const routine of routineData) {
    if (nowMinutes <= timeToMinutes(routine.time)) {
      nextTask = routine.task;
      break;
    }
  }

  footer.textContent = `今やるべきタスク：${nextTask}`;
};

// フォーム表示切替
window.toggleForm = function(childId) {
  const form = document.getElementById(`form-${childId}`);
  form.style.display = (form.style.display === "none" || form.style.display === "") ? "block" : "none";
};

// ✅ turbo:load：すべてまとめてここで定義
document.addEventListener("turbo:load", () => {
  // ✅ 共通：モーダルが閉じたら .alert 消す
  document.querySelectorAll(".modal").forEach(modalEl => {
    modalEl.addEventListener("hidden.bs.modal", () => {
      modalEl.querySelectorAll(".alert").forEach(alert => alert.remove());
    });
  });

  // ✅ 通常のモーダル表示（data-open-modal）
  const modalId = document.body.dataset.openModal;
  if (modalId) {
    const modalEl = document.getElementById(modalId);
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
      document.body.dataset.openModal = ""; // ←再表示防止
    }
  }

  // ✅ 病院モーダル再表示（新規 or 編集）
  const hospitalModalError = document.body.dataset.hospitalModalError;

  if (hospitalModalError) {
    const modalId = hospitalModalError === "new"
      ? "newHospitalModal"
      : `editHospitalModal-${hospitalModalError}`;
    const modalEl = document.getElementById(modalId);

    if (modalEl) {
      // 既にモーダルが開いていたら閉じてから再表示
      const opened = document.querySelector(".modal.show");
      if (opened && opened.id !== modalId) {
        const openedInstance = bootstrap.Modal.getInstance(opened);
        if (openedInstance) {
          opened.addEventListener("hidden.bs.modal", () => {
            new bootstrap.Modal(modalEl).show();
          }, { once: true });
          openedInstance.hide();
        } else {
          new bootstrap.Modal(modalEl).show();
        }
      } else {
        new bootstrap.Modal(modalEl).show();
      }

      document.body.dataset.hospitalModalError = "";
    }
  }

  // ✅ 子どもモーダル（new/edit）
  const childModalError = document.body.dataset.childModalError;
  if (childModalError === "new") {
    const modal = new bootstrap.Modal(document.getElementById("childModal"));
    modal.show();
    document.body.dataset.childModalError = "";
  } else if (childModalError === "edit") {
    const modal = new bootstrap.Modal(document.getElementById("editChildModal"));
    modal.show();
    document.body.dataset.childModalError = "";
  }

  // ✅ ルーティンモーダル（エラー用）
  const routineModalError = document.body.dataset.routineModalError;
  if (routineModalError === "true") {
    const modalEl = document.getElementById("routineModal");
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
      document.body.dataset.routineModalError = "";

      modalEl.addEventListener("hidden.bs.modal", () => {
        modalEl.querySelectorAll(".alert").forEach(alert => alert.remove());
      });

      const form = modalEl.querySelector("form");
      if (form) {
        const attributes = JSON.parse(document.body.dataset.routineAttributes || "{}");
        form.querySelector("[name='routine[time]']").value = attributes.time || "";
        form.querySelector("[name='routine[task]']").value = attributes.task || "";
        form.querySelector("[name='routine[memo]']").value = attributes.memo || "";
      }
    }
  }

  // ✅ 記録モーダルの初期値セット
  const recordModal = document.getElementById("recordModal");
  if (recordModal) {
    recordModal.addEventListener("show.bs.modal", event => {
      const button = event.relatedTarget;
      const task = button?.getAttribute("data-task");
      if (task) {
        const select = recordModal.querySelector("#record_record_type");
        if (select) select.value = task;
      }
    });
  }

  // ✅ 病院ページで ×ボタン押すとトップへ戻る
  document.querySelectorAll(".modal .btn-close").forEach(btn => {
    btn.addEventListener("click", () => {
      if (location.pathname.match(/^\/hospitals\/\d+$/)) {
        window.location.href = "/";
      }
    });
  });
  // ✅ 病院新規登録モーダル（エラー付き再表示）
  const hospitalErrors = JSON.parse(document.body.dataset.hospitalErrors || "[]");
  const hospitalAttributes = JSON.parse(document.body.dataset.hospitalAttributes || "{}");

  if (document.body.dataset.hospitalModalError === "new") {
    const modalEl = document.getElementById("newHospitalModal");
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
      document.body.dataset.hospitalModalError = "";

      // 入力値の再設定
      const form = modalEl.querySelector("form");
      if (form) {
        form.querySelector("[name='hospital[name]']").value = hospitalAttributes.name || "";
        form.querySelector("[name='hospital[phone_number]']").value = hospitalAttributes.phone_number || "";
      }
    }
  }
  // ✅ 育児記録モーダル（エラー付き再表示）
  const recordModalError = document.body.dataset.recordModalError;
  const recordErrors = JSON.parse(document.body.dataset.recordErrors || "[]");
  const recordAttributes = JSON.parse(document.body.dataset.recordAttributes || "{}");

  if (recordModalError === "true") {
    const modalEl = document.getElementById("recordModal");
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
      document.body.dataset.recordModalError = "";

      // エラー表示


      // 入力値の再反映
      const form = modalEl.querySelector("form");
      if (form) {
        form.querySelector("[name='record[record_type]']").value = recordAttributes.record_type || "";
        form.querySelector("[name='record[quantity]']").value = recordAttributes.quantity || "";
        form.querySelector("[name='record[recorded_at]']").value = recordAttributes.recorded_at || "";
        form.querySelector("[name='record[memo]']").value = recordAttributes.memo || "";
      }
    }
  }
  // ✅ 記録編集モーダル（エラー付き再表示）
  const editModalId = document.body.dataset.openModal;
  if (editModalId && editModalId.startsWith("editRecordModal-")) {
    const modalEl = document.getElementById(editModalId);
    if (modalEl) {
      // モーダル初期化インスタンスがあれば破棄
      const existingModal = bootstrap.Modal.getInstance(modalEl);
      if (existingModal) existingModal.dispose();

      const modal = new bootstrap.Modal(modalEl);
      modal.show();

      // 明示的に backdrop と open クラスを削除（閉じないバグ対策）
      document.body.classList.remove("modal-open");
      document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());

      document.body.dataset.openModal = ""; // 再実行防止

      const recordErrors = JSON.parse(document.body.dataset.recordErrors || "[]");
      if (recordErrors.length > 0) {
        const alertDiv = document.createElement("div");
        alertDiv.className = "alert alert-danger";
        const ul = document.createElement("ul");
        ul.classList.add("mb-0");
        recordErrors.forEach(msg => {
          const li = document.createElement("li");
          li.textContent = msg;
          ul.appendChild(li);
        });
        alertDiv.appendChild(ul);

        const form = modalEl.querySelector("form");
        if (form) form.prepend(alertDiv);
      }
    }
  }

  const editChildModal = document.getElementById("editChildModal");
  if (editChildModal) {
    editChildModal.addEventListener("hidden.bs.modal", () => {
      const errorBox = document.getElementById("edit-child-error");
      if (errorBox) errorBox.remove();
    });
  }

  const newChildModal = document.getElementById("childModal");
  if (newChildModal) {
    newChildModal.addEventListener("hidden.bs.modal", () => {
      const errorBox = document.getElementById("new-child-error");
      if (errorBox) errorBox.remove();
    });
  }

  // モーダルの余計な backdrop を除去する関数
  function cleanupBackdrop() {
    document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());
    document.body.classList.remove("modal-open");
  }

  // モーダルを安全に連続表示するための関数
  function openModalSafely(targetId) {
    cleanupBackdrop(); // ← 余計な backdrop を除去

    const openedModal = document.querySelector(".modal.show");
    const targetModal = document.getElementById(targetId);
    if (!targetModal) return;

    if (openedModal) {
      const openedInstance = bootstrap.Modal.getInstance(openedModal);
      openedModal.addEventListener("hidden.bs.modal", () => {
        new bootstrap.Modal(targetModal).show();
      }, { once: true });
      openedInstance.hide();
    } else {
      new bootstrap.Modal(targetModal).show();
    }
  }

  // ✅ 推奨：data-open-next-modal による制御（編集ボタンなど）
  document.querySelectorAll("[data-open-next-modal]").forEach(button => {
    button.addEventListener("click", event => {
      event.preventDefault();
      const nextModalId = button.dataset.openNextModal;
      openModalSafely(nextModalId);
    });
  });

  // ✅ 補足：従来の data-bs-toggle="modal" による対応（必要なら残す）
  document.querySelectorAll("[data-bs-toggle='modal'][data-bs-target^='#editRoutineModal-']").forEach(btn => {
    btn.addEventListener("click", () => {
      const modalId = btn.getAttribute("data-bs-target").replace("#", "");
      openModalSafely(modalId);
    });
  });

  // 緊急連絡先モーダルが閉じられたら、エラーメッセージを削除する
  document.querySelectorAll("[id^='editHospitalModal-'], #newHospitalModal").forEach(modalEl => {
    modalEl.addEventListener("hidden.bs.modal", () => {
      modalEl.querySelectorAll(".alert").forEach(alert => alert.remove());
    });
  });

  if ("serviceWorker" in navigator && "PushManager" in window) {
    navigator.serviceWorker.ready.then(async (registration) => {
      const permission = await Notification.requestPermission();
      if (permission !== "granted") return;

      const publicKey = "<%= ENV['VAPID_PUBLIC_KEY'] %>"; // 後ほどERBで埋め込む
      const convertedKey = urlBase64ToUint8Array(publicKey);

      const subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: convertedKey
      });

      // サーバーに送信（すでに登録されている場合は無視）
      await fetch("/subscriptions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify(subscription.toJSON())
      });
    });
  }

  // careRelationshipListModalが閉じられたときにページをリロード
  const careRelationshipListModal = document.getElementById("careRelationshipListModal");
  if (careRelationshipListModal) {
    careRelationshipListModal.addEventListener("hidden.bs.modal", () => {
      window.location.reload();
    });
  }

  console.log("✅ Turbo再バインド中...");

  document.querySelectorAll(".clickable-image").forEach((img) => {
    img.addEventListener("click", () => {
      const modal = document.getElementById("imagePreviewModal");
      const preview = document.getElementById("previewImage");
      if (!modal || !preview) return;

      preview.src = img.dataset.imageUrl;

      const opened = document.querySelector(".modal.show");
      if (opened) {
        const instance = bootstrap.Modal.getInstance(opened);
        opened.addEventListener("hidden.bs.modal", () => {
          new bootstrap.Modal(modal).show();
        }, { once: true });
        instance.hide();
      } else {
        new bootstrap.Modal(modal).show();
      }
    });
  });

  // 画像プレビューモーダルが閉じられたとき、routineDetailModalが開いていなければ再度開く
  const imagePreviewModal = document.getElementById("imagePreviewModal");
  const routineDetailModal = document.getElementById("routineDetailModal");

  if (imagePreviewModal && routineDetailModal) {
    imagePreviewModal.addEventListener("hidden.bs.modal", () => {
      const isRoutineModalOpen = routineDetailModal.classList.contains("show");
      if (!isRoutineModalOpen) {
        const openedModal = document.querySelector(".modal.show");
        if (openedModal) {
          const openedInstance = bootstrap.Modal.getInstance(openedModal);
          openedModal.addEventListener("hidden.bs.modal", () => {
            bootstrap.Modal.getOrCreateInstance(routineDetailModal).show();
          }, { once: true });
          openedInstance.hide();
        } else {
          bootstrap.Modal.getOrCreateInstance(routineDetailModal).show();
        }
      }
    });
  }

  // ✅ ルーティン編集モーダル：開くと routineDetailModal を閉じる
  document.querySelectorAll("[data-bs-target^='#editRoutineModal-']").forEach(button => {
    button.addEventListener("click", (e) => {
      const targetId = button.getAttribute("data-bs-target").replace("#", "");
      const targetModal = document.getElementById(targetId);
      const routineDetailModal = document.getElementById("routineDetailModal");

      if (!targetModal) return;

      const openedModal = document.querySelector(".modal.show");
      const showTargetModal = () => {
        const modal = new bootstrap.Modal(targetModal);
        modal.show();
      };

      if (openedModal && openedModal.id !== targetId) {
        const openedInstance = bootstrap.Modal.getInstance(openedModal);
        if (openedInstance) {
          openedModal.addEventListener("hidden.bs.modal", () => {
            showTargetModal();
          }, { once: true });
          openedInstance.hide();
        } else {
          showTargetModal();
        }
      } else {
        showTargetModal();
      }
    });
  });

  // ✅ ルーティン編集モーダル：閉じたら routineDetailModal を再表示
  document.querySelectorAll("[id^='editRoutineModal-']").forEach(modalEl => {
    modalEl.addEventListener("hidden.bs.modal", () => {
      const routineDetailModal = document.getElementById("routineDetailModal");
      if (!routineDetailModal.classList.contains("show")) {
        bootstrap.Modal.getOrCreateInstance(routineDetailModal).show();
      }
    });
  });

  // ✅ ルーティン編集フォーム送信後、成功したら routineDetailModal を再表示
  document.querySelectorAll("[id^='editRoutineModal-'] form").forEach(form => {
    form.addEventListener("turbo:submit-end", (event) => {
      if (event.detail.success) {
        const routineDetailModal = document.getElementById("routineDetailModal");
        if (!routineDetailModal) return;

        const openedModal = document.querySelector(".modal.show");
        if (openedModal) {
          const openedInstance = bootstrap.Modal.getInstance(openedModal);
          openedModal.addEventListener("hidden.bs.modal", () => {
            bootstrap.Modal.getOrCreateInstance(routineDetailModal).show();
          }, { once: true });
          openedInstance.hide();
        } else {
          bootstrap.Modal.getOrCreateInstance(routineDetailModal).show();
        }
      }
    });
  });

  // ✅ routineDetailModal を閉じたとき、他にモーダルが残っていたら backdrop を正しく整理
  const routineDetailModalEl = document.getElementById("routineDetailModal");
  if (routineDetailModalEl) {
    routineDetailModalEl.addEventListener("hidden.bs.modal", () => {
      // まだ開いているモーダルがあれば backdrop を残す、それ以外は削除
      const stillOpen = document.querySelector(".modal.show");
      if (!stillOpen) {
        // 明示的に backdrop を削除（暗転バグ対策）
        document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());
        document.body.classList.remove("modal-open");
      }
    });
  }
});

// VAPID鍵用デコード関数
function urlBase64ToUint8Array(base64String) {
  const padding = "=".repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding).replace(/\-/g, "+").replace(/_/g, "/");
  const raw = atob(base64);
  return new Uint8Array([...raw].map(c => c.charCodeAt(0)));
}

document.addEventListener("DOMContentLoaded", () => {
  const button = document.getElementById("subscribeButton");
  if (!button) return;

  button.addEventListener("click", async () => {
    const registration = await register();
    const subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: VAPID_PUBLIC_KEY // VAPIDの公開鍵をJS側に埋め込む必要あり
    });

    await fetch("/settings/subscribe", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        user: { subscription_token: JSON.stringify(subscription) }
      })
    });

    alert("通知を許可しました！");
  });
});

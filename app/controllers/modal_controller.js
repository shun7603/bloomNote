import { Controller } from "@hotwired/stimulus"

// モーダルを自動で閉じる Stimulusコントローラ
export default class extends Controller {
  static values = { targetId: String }

  connect() {
    // 指定されたIDのモーダル要素を取得
    const modalElement = document.getElementById(this.targetIdValue)

    // Bootstrapのモーダルインスタンスを取得（なければ作成）
    const modal = bootstrap.Modal.getInstance(modalElement) || new bootstrap.Modal(modalElement)

    // モーダルを閉じる
    modal.hide()
  }
}
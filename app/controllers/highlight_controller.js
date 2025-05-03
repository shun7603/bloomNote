import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.classList.add("highlight")
    setTimeout(() => {
      this.element.classList.remove("highlight")
    }, 2000) // アニメーション後にクラスを外す（2秒）
  }
}
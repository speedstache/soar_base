import { Controller } from "@hotwired/stimulus"
import Cropper from "cropperjs"

export default class extends Controller {
  static targets = ["input", "image", "editor", "zoom", "submit"]
  static values = { maxSize: Number }

  connect() {
    this.cropper = null
  }

  disconnect() {
    this.cropper?.destroy()
    this.previewUrl && URL.revokeObjectURL(this.previewUrl)
  }

  load() {
    const file = this.inputTarget.files[0]
    if (!file) return

    if (file.size > this.maxSizeValue) {
      this.inputTarget.setCustomValidity("Choose an image no larger than 5 MiB.")
      this.inputTarget.reportValidity()
      this.inputTarget.value = ""
      return
    }

    this.inputTarget.setCustomValidity("")
    this.cropper?.destroy()
    this.previewUrl && URL.revokeObjectURL(this.previewUrl)
    this.zoomTarget.value = "0"
    this.previewUrl = URL.createObjectURL(file)
    this.imageTarget.onload = () => {
      this.cropper = new Cropper(this.imageTarget, {
        aspectRatio: 1,
        viewMode: 1,
        autoCropArea: 1,
        movable: true,
        zoomable: true,
        cropBoxMovable: false,
        cropBoxResizable: false
      })
      this.baseZoom = this.cropper.getImageData().ratio
      this.editorTarget.hidden = false
      this.submitTarget.disabled = false
    }
    this.imageTarget.src = this.previewUrl
  }

  zoom() {
    if (!this.cropper) return
    this.cropper.zoomTo(this.baseZoom * (1 + 2 * Number(this.zoomTarget.value)))
  }

  submit(event) {
    if (this.submittingCroppedImage) {
      this.submittingCroppedImage = false
      return
    }

    if (!this.cropper) return

    event.preventDefault()
    this.submitTarget.disabled = true
    this.cropper.getCroppedCanvas({ width: 512, height: 512, imageSmoothingQuality: "high" }).toBlob((blob) => {
      if (!blob || blob.size > this.maxSizeValue) {
        this.submitTarget.disabled = false
        this.inputTarget.setCustomValidity("The cropped image must be no larger than 5 MiB.")
        this.inputTarget.reportValidity()
        return
      }

      const croppedFile = new File([blob], "profile-image.png", { type: "image/png" })
      const transfer = new DataTransfer()
      transfer.items.add(croppedFile)
      this.inputTarget.files = transfer.files
      this.submittingCroppedImage = true
      this.element.querySelector("form").requestSubmit()
    }, "image/png")
  }
}
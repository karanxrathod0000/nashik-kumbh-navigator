import qrcode
from PIL import Image, ImageDraw, ImageFont
import os

def generate_field_poster_qr():
    url = "https://github.com/karanparanox/nashik-kumbh-navigator/releases/latest"
    qr = qrcode.QRCode(
        version=4,
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=16,
        border=2,
    )
    qr.add_data(url)
    qr.make(fit=True)
    qr_img = qr.make_image(fill_color="#1E1B4B", back_color="white").convert("RGB")

    # Create branded poster canvas (1200x1400)
    canvas = Image.new("RGB", (1200, 1450), "#FFFFFF")
    draw = ImageDraw.Draw(canvas)

    # Top saffron header banner
    draw.rectangle([0, 0, 1200, 220], fill="#FF8C42")
    draw.rectangle([0, 210, 1200, 225], fill="#5B21B6")

    try:
        font_title = ImageFont.truetype("arial.ttf", 54)
        font_sub = ImageFont.truetype("arial.ttf", 36)
        font_url = ImageFont.truetype("arial.ttf", 38)
        font_note = ImageFont.truetype("arial.ttf", 30)
    except:
        font_title = font_sub = font_url = font_note = ImageFont.load_default()

    draw.text((120, 50), "NASHIK KUMBH NAVIGATOR", fill="white", font=font_title)
    draw.text((120, 130), "OFFICIAL PILGRIM SAFETY & MAPS • SIMHASTHA 2027", fill="#1E1B4B", font=font_sub)

    # Paste QR in center
    qr_w, qr_h = qr_img.size
    offset_x = (1200 - qr_w) // 2
    offset_y = 300
    canvas.paste(qr_img, (offset_x, offset_y))

    # Border around QR
    draw.rectangle([offset_x - 8, offset_y - 8, offset_x + qr_w + 8, offset_y + qr_h + 8], outline="#FF8C42", width=6)

    # Instructions below QR
    draw.text((180, offset_y + qr_h + 40), "SCAN TO DOWNLOAD OFFICIAL RELEASE APK", fill="#1E1B4B", font=font_url)
    draw.text((220, offset_y + qr_h + 110), "Direct Link: github.com/karanparanox/nashik-kumbh-navigator/releases/latest", fill="#4B5563", font=font_note)
    draw.text((320, offset_y + qr_h + 160), "Allow 'Install Unknown Apps' when prompted.", fill="#DC2626", font=font_note)

    os.makedirs("dist/bin", exist_ok=True)
    out_path = "dist/bin/kumbh_navigator_download_qr.png"
    canvas.save(out_path, "PNG")
    print(f"Branded QR Code generated -> {out_path}")

if __name__ == "__main__":
    generate_field_poster_qr()

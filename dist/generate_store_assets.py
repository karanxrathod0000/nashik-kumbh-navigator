import os
from PIL import Image, ImageDraw, ImageFont

def create_dirs():
    os.makedirs("dist/assets/store/screenshots/phone", exist_ok=True)
    os.makedirs("dist/assets/store/screenshots/tablet", exist_ok=True)

def draw_gradient(draw, width, height, c1, c2, vertical=True):
    for i in range(height if vertical else width):
        ratio = i / float((height if vertical else width) - 1)
        r = int(c1[0] * (1 - ratio) + c2[0] * ratio)
        g = int(c1[1] * (1 - ratio) + c2[1] * ratio)
        b = int(c1[2] * (1 - ratio) + c2[2] * ratio)
        if vertical:
            draw.line([(0, i), (width, i)], fill=(r, g, b))
        else:
            draw.line([(i, 0), (i, height)], fill=(r, g, b))

def generate_icon():
    img = Image.new("RGB", (512, 512))
    draw = ImageDraw.Draw(img)
    # Saffron to Royal Violet gradient
    draw_gradient(draw, 512, 512, (255, 140, 66), (91, 33, 182))
    
    # Outer golden ring
    draw.ellipse([56, 56, 456, 456], outline=(255, 215, 0), width=12)
    # Inner circle
    draw.ellipse([80, 80, 432, 432], fill=(255, 255, 255))
    
    # Sacred Kumbh Kalash geometric emblem
    draw.polygon([(256, 130), (180, 230), (332, 230)], fill=(255, 140, 66))
    draw.ellipse([170, 210, 342, 360], fill=(91, 33, 182))
    draw.ellipse([190, 230, 322, 340], fill=(255, 215, 0))
    # Navigation compass needle
    draw.polygon([(256, 170), (236, 280), (256, 260)], fill=(255, 80, 50))
    draw.polygon([(256, 170), (276, 280), (256, 260)], fill=(200, 40, 20))
    
    img.save("dist/assets/store/icon_512x512.png", "PNG")
    print("Generated 512x512 App Icon -> dist/assets/store/icon_512x512.png")

def generate_banner():
    img = Image.new("RGB", (1024, 500))
    draw = ImageDraw.Draw(img)
    # Sky blue to Saffron gold gradient
    draw_gradient(draw, 1024, 500, (30, 41, 59), (91, 33, 182), vertical=False)
    
    # Grid lines / map overlay
    for x in range(0, 1024, 60):
        draw.line([(x, 0), (x, 500)], fill=(255, 255, 255, 30), width=1)
    for y in range(0, 500, 60):
        draw.line([(0, y), (1024, y)], fill=(255, 255, 255, 30), width=1)

    # Decorative circles
    draw.ellipse([680, 60, 960, 340], outline=(255, 140, 66), width=8)
    draw.ellipse([720, 100, 920, 300], fill=(255, 140, 66))
    
    # Text banner simulation (using clean geometric shapes or default font)
    try:
        font_large = ImageFont.truetype("arial.ttf", 46)
        font_sub = ImageFont.truetype("arial.ttf", 26)
    except:
        font_large = font_sub = ImageFont.load_default()
    
    draw.text((60, 140), "NASHIK KUMBH NAVIGATOR", fill=(255, 215, 0), font=font_large)
    draw.text((60, 210), "Simhastha 2027 • Live Maps • Crowd Safety • SOS 108", fill=(255, 255, 255), font=font_sub)
    draw.text((60, 280), "Your Safe Path to the Sacred Ghats", fill=(226, 232, 240), font=font_sub)
    
    img.save("dist/assets/store/feature_banner_1024x500.png", "PNG")
    print("Generated 1024x500 Feature Banner -> dist/assets/store/feature_banner_1024x500.png")

def generate_phone_screenshots():
    titles = [
        ("01_onboarding_safety.png", "Live Crowd & Safety Alerts", "Stay updated with real-time heatmaps"),
        ("02_live_dashboard.png", "Nashik Kumbh Dashboard", "Quick access to Ghats, Shahi Snan & Weather"),
        ("03_ghat_crowd_map.png", "Ramkund & Kushavarta Maps", "Navigate safe pedestrian routes offline"),
        ("04_sos_108_emergency.png", "One-Tap SOS 108 Emergency", "Instant location sharing with Police & Medical"),
        ("05_shahi_snan_schedules.png", "Shahi Snan Bathing Dates", "Auspicious muhurat timers & crowd forecast")
    ]
    for filename, title, sub in titles:
        img = Image.new("RGB", (1080, 1920))
        draw = ImageDraw.Draw(img)
        draw_gradient(draw, 1080, 1920, (15, 23, 42), (49, 46, 129))
        
        # Phone frame mock UI
        draw.rounded_rectangle([80, 260, 1000, 1800], radius=40, fill=(255, 255, 255))
        draw.rounded_rectangle([120, 300, 960, 480], radius=24, fill=(91, 33, 182))
        draw.rounded_rectangle([120, 520, 960, 1000], radius=24, fill=(241, 245, 249))
        draw.rounded_rectangle([120, 1040, 960, 1300], radius=24, fill=(255, 240, 227))
        draw.rounded_rectangle([120, 1340, 960, 1720], radius=24, fill=(238, 242, 255))
        
        try:
            font_t = ImageFont.truetype("arial.ttf", 52)
            font_s = ImageFont.truetype("arial.ttf", 36)
            font_ui = ImageFont.truetype("arial.ttf", 40)
        except:
            font_t = font_s = font_ui = ImageFont.load_default()
            
        draw.text((90, 80), title, fill=(255, 215, 0), font=font_t)
        draw.text((90, 160), sub, fill=(226, 232, 240), font=font_s)
        draw.text((160, 360), "Nashik Kumbh Mela 2027", fill=(255, 255, 255), font=font_ui)
        
        path = os.path.join("dist/assets/store/screenshots/phone", filename)
        img.save(path, "PNG")
        print(f"Generated Phone Screenshot -> {path}")

def generate_tablet_screenshots():
    titles = [
        ("01_tablet_dashboard_map.png", "High-Resolution Tablet Dashboard & Map View"),
        ("02_tablet_ghat_directory.png", "Complete Sector & Ghat Directory across Nashik"),
        ("03_tablet_emergency_network.png", "Real-Time Emergency Control & SOS Command")
    ]
    for filename, title in titles:
        img = Image.new("RGB", (1920, 1200))
        draw = ImageDraw.Draw(img)
        draw_gradient(draw, 1920, 1200, (30, 41, 59), (91, 33, 182), vertical=False)
        
        draw.rounded_rectangle([100, 180, 1820, 1100], radius=40, fill=(255, 255, 255))
        draw.rounded_rectangle([160, 240, 860, 1040], radius=24, fill=(241, 245, 249))
        draw.rounded_rectangle([920, 240, 1760, 1040], radius=24, fill=(255, 245, 235))
        
        try:
            font_t = ImageFont.truetype("arial.ttf", 56)
        except:
            font_t = ImageFont.load_default()
            
        draw.text((100, 70), title, fill=(255, 215, 0), font=font_t)
        
        path = os.path.join("dist/assets/store/screenshots/tablet", filename)
        img.save(path, "PNG")
        print(f"Generated Tablet Screenshot -> {path}")

if __name__ == "__main__":
    create_dirs()
    generate_icon()
    generate_banner()
    generate_phone_screenshots()
    generate_tablet_screenshots()
    print("All Store Assets generated successfully!")

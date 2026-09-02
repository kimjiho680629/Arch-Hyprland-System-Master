#!/usr/bin/env bash
set -e

echo "=========================================================="
echo "   ML4W Custom GRUB 테마 및 해상도 최적화 설정 스크립트   "
echo "=========================================================="

# 1. 테마 디렉토리 준비
echo ":: 1. GRUB 커스텀 테마 디렉토리 생성..."
sudo mkdir -p /boot/grub/themes/ml4w-custom

# 2. Whitesur 테마의 리소스 복사 (아이콘, 폰트, 선택바 템플릿)
echo ":: 2. Whitesur 테마 에셋(아이콘, 폰트) 복사..."
if [ -d /usr/share/grub/themes/whitesur ]; then
    sudo cp -rf /usr/share/grub/themes/whitesur/icons /boot/grub/themes/ml4w-custom/
    sudo cp -f /usr/share/grub/themes/whitesur/*.pf2 /boot/grub/themes/ml4w-custom/
    sudo cp -f /usr/share/grub/themes/whitesur/info.png /boot/grub/themes/ml4w-custom/
    sudo cp -f /usr/share/grub/themes/whitesur/select_*.png /boot/grub/themes/ml4w-custom/
else
    echo "   - [주의] /usr/share/grub/themes/whitesur 디렉토리를 찾을 수 없어 기본 템플릿을 내려받아 사용합니다."
    rm -rf /tmp/whitesur-fallback
    git clone --depth 1 https://github.com/vinceliuice/grub2-themes /tmp/whitesur-fallback
    sudo cp -rf /tmp/whitesur-fallback/themes/whitesur/icons /boot/grub/themes/ml4w-custom/
    sudo cp -f /tmp/whitesur-fallback/themes/whitesur/*.pf2 /boot/grub/themes/ml4w-custom/
    sudo cp -f /tmp/whitesur-fallback/themes/whitesur/info.png /boot/grub/themes/ml4w-custom/
    sudo cp -f /tmp/whitesur-fallback/themes/whitesur/select_*.png /boot/grub/themes/ml4w-custom/
    rm -rf /tmp/whitesur-fallback
fi

# 2.5. Inter 폰트를 GRUB 전용 .pf2 포맷으로 빌드
echo ":: 2.5. Inter 폰트 PF2 변환 및 생성..."
if [ -f "/usr/share/fonts/inter/InterVariable.ttf" ]; then
    sudo grub-mkfont --output=/boot/grub/themes/ml4w-custom/inter_16.pf2 --size=16 /usr/share/fonts/inter/InterVariable.ttf
    sudo grub-mkfont --output=/boot/grub/themes/ml4w-custom/inter_14.pf2 --size=14 /usr/share/fonts/inter/InterVariable.ttf
    echo "   - Inter 폰트 빌드 완료 (14px, 16px)"
else
    echo "   - [주의] InterVariable.ttf를 찾을 수 없습니다. 기본 템플릿 폰트(Fira Code 등)를 유지합니다."
fi

# 3. 사용자 테마 색상(colors.json) 로드 및 선택바 리컬러(Recolor)
echo ":: 3. 시스템 테마 색상에 맞춘 에셋 리컬러링..."
COLOR_FILE="/home/kjh/.config/ml4w/colors/colors.json"
if [ -f "$COLOR_FILE" ]; then
    PRIMARY=$(jq -r '.primary' "$COLOR_FILE")
    ON_SURFACE=$(jq -r '.on_surface' "$COLOR_FILE")
else
    PRIMARY="#bfc1ff"
    ON_SURFACE="#e4e1e9"
fi

# magick을 이용해 select_*.png 이미지들의 색상을 PRIMARY 색상으로 틴트(Tint) 및 반투명(Glassmorphism) 처리합니다.
sudo magick /boot/grub/themes/ml4w-custom/select_w.png -fill "$PRIMARY" -tint 100% -channel A -evaluate multiply 0.7 +channel /boot/grub/themes/ml4w-custom/select_w.png
sudo magick /boot/grub/themes/ml4w-custom/select_c.png -fill "$PRIMARY" -tint 100% -channel A -evaluate multiply 0.7 +channel /boot/grub/themes/ml4w-custom/select_c.png
sudo magick /boot/grub/themes/ml4w-custom/select_e.png -fill "$PRIMARY" -tint 100% -channel A -evaluate multiply 0.7 +channel /boot/grub/themes/ml4w-custom/select_e.png

# 4. 배경화면 복사 및 3440x1440 해상도 크롭/리사이즈 변환
echo ":: 4. 현재 배경화면 이미지 변환 및 크롭 (3440x1440)..."
SOURCE_WALLPAPER="/home/kjh/.config/ml4w/wallpapers/Gemini_Generated_Image_1431ht1431ht1431.png"
DEST_WALLPAPER="/boot/grub/themes/ml4w-custom/background.png"

if [ -f "$SOURCE_WALLPAPER" ]; then
    sudo magick "$SOURCE_WALLPAPER" -resize 3440x1440^ -gravity center -extent 3440x1440 "$DEST_WALLPAPER"
    echo "   - 배경화면 설정 완료!"
else
    echo "   - [에러] 배경화면 파일을 찾을 수 없습니다: $SOURCE_WALLPAPER"
    exit 1
fi

# 5. theme.txt 설정 파일 작성
echo ":: 5. 커스텀 theme.txt 생성..."
# 사용할 폰트 지정 (Inter 폰트 빌드 성공 여부에 따라 다르게 선언 가능하도록 변수 처리)
FONT_MENU="inter_16.pf2"
FONT_LABEL="inter_14.pf2"
if [ ! -f "/boot/grub/themes/ml4w-custom/inter_16.pf2" ]; then
    FONT_MENU="firacode.pf2"
    FONT_LABEL="firacode.pf2"
fi

sudo tee /boot/grub/themes/ml4w-custom/theme.txt > /dev/null <<EOF
# GRUB2 gfxmenu Custom Theme
# Generated automatically by Antigravity AI

# Global Property
title-text: ""
desktop-image: "background.png"
desktop-color: "#131318"
terminal-font: "Terminus Regular 14"
terminal-box: "terminal_box_*.png"
terminal-width: "100%"
terminal-height: "100%"
terminal-border: "0"

# Show the boot menu (Centered layout for Ultrawide)
+ boot_menu {
  left = 50%-300
  top = 50%-180
  width = 600
  height = 360
  item_font = "${FONT_MENU}"
  item_color = "${ON_SURFACE}"
  selected_item_color = "${PRIMARY}"
  icon_width = 32
  icon_height = 32
  item_icon_space = 24
  item_height = 42
  item_padding = 8
  item_spacing = 12
  selected_item_pixmap_style = "select_*.png"
}

# Bottom Info Bar
+ image {
  top = 100%-50
  left = 50%-240
  width = 480
  height = 42
  file = "info.png"
}

# Countdown label
+ label {
  top = 50%+200
  left = 50%-300
  width = 600
  align = "center"
  id = "__timeout__"
  text = "Booting in %d seconds"
  color = "#8b898f"
  font = "${FONT_LABEL}"
}
EOF

# 6. /etc/default/grub 설정 수정
echo ":: 6. /etc/default/grub 설정 적용..."
sudo cp /etc/default/grub /etc/default/grub.bak
echo "   - 기존 GRUB 설정을 /etc/default/grub.bak에 백업했습니다."

if grep -q "^GRUB_THEME=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/ml4w-custom/theme.txt"|' /etc/default/grub
else
    echo 'GRUB_THEME="/boot/grub/themes/ml4w-custom/theme.txt"' | sudo tee -a /etc/default/grub
fi

sudo sed -i 's|^GRUB_BACKGROUND=|#GRUB_BACKGROUND=|' /etc/default/grub

# 7. GRUB 부트로더 설정 재빌드
echo ":: 7. GRUB 부트로더 설정 재빌드..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "=========================================================="
echo " GRUB 테마 및 해상도 최적화 설정이 성공적으로 완료되었습니다!"
echo " 재부팅 시 새로운 GRUB 부팅 테마가 적용됩니다."
echo "=========================================================="

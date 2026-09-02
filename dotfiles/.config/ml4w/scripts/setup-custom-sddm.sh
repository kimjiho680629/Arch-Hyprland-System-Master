#!/usr/bin/env bash
set -e

echo "=========================================================="
echo "   ML4W Custom SDDM 테마 설치 및 색상 매칭 설정 스크립트   "
echo "=========================================================="

# 1. 패키지 설치
echo ":: 1. 필수 패키지 설치 중 (sudo 권한 필요)..."
sudo pacman -S --needed --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg imagemagick git jq

# 2. 테마 디렉토리 준비
echo ":: 2. ML4W SDDM 테마 다운로드 및 배치..."
rm -rf /tmp/ml4w-sddm-clone
git clone --depth 1 https://github.com/mylinuxforwork/ml4w-sddm /tmp/ml4w-sddm-clone
sudo mkdir -p /usr/share/sddm/themes/ml4w
sudo cp -rf /tmp/ml4w-sddm-clone/. /usr/share/sddm/themes/ml4w/
rm -rf /tmp/ml4w-sddm-clone

# 3. 배경화면 복사 및 변환
echo ":: 3. 현재 사용 중인 배경화면 적용 중..."
SOURCE_WALLPAPER="/home/kjh/.config/ml4w/wallpapers/Gemini_Generated_Image_1431ht1431ht1431.png"
DEST_WALLPAPER="/usr/share/sddm/themes/ml4w/backgrounds/ml4w.jpg"

if [ -f "$SOURCE_WALLPAPER" ]; then
    echo "   - 이미지 변환 (PNG -> JPG) 및 복사..."
    sudo magick "$SOURCE_WALLPAPER" "/tmp/current_wallpaper_sddm.jpg"
    sudo cp "/tmp/current_wallpaper_sddm.jpg" "$DEST_WALLPAPER"
    sudo rm -f "/tmp/current_wallpaper_sddm.jpg"
    echo "   - 배경화면 설정 완료!"
else
    echo "   - [에러] 배경화면 파일을 찾을 수 없습니다: $SOURCE_WALLPAPER"
    exit 1
fi

# 4. 사용자의 현재 테마 색상(colors.json)에 맞춘 ml4w.conf 커스텀 파일 생성
echo ":: 4. 현재 배경화면 색상 팔레트 맞춤형 디자인 설정..."
COLOR_FILE="/home/kjh/.config/ml4w/colors/colors.json"
if [ -f "$COLOR_FILE" ]; then
    PRIMARY=$(jq -r '.primary' "$COLOR_FILE")
    BACKGROUND=$(jq -r '.background' "$COLOR_FILE")
    SURFACE_CONTAINER=$(jq -r '.surface_container' "$COLOR_FILE")
    ON_SURFACE=$(jq -r '.on_surface' "$COLOR_FILE")
    ON_PRIMARY=$(jq -r '.on_primary' "$COLOR_FILE")
    OUTLINE=$(jq -r '.outline' "$COLOR_FILE")
    ERROR=$(jq -r '.error' "$COLOR_FILE")
else
    # fallback colors
    PRIMARY="#bfc1ff"
    BACKGROUND="#131318"
    SURFACE_CONTAINER="#1f1f25"
    ON_SURFACE="#e4e1e9"
    ON_PRIMARY="#282a60"
    OUTLINE="#918f9a"
    ERROR="#ffb4ab"
fi

# /usr/share/sddm/themes/ml4w/configs/ml4w.conf 수정
# 테두리 라운드 처리(radius: 12) 및 유리 효과(Glassmorphism) 스타일링
sudo tee /usr/share/sddm/themes/ml4w/configs/ml4w.conf > /dev/null <<EOF
; Custom SDDM theme config matching current wallpaper colors
; Generated automatically by Antigravity AI

[General]
scale = 1.0
enable-animations = true
animated-background-placeholder = ""
background-fill-mode = "fill"

[LockScreen]
display = true
padding-top = 0
padding-right = 0
padding-bottom = 0
padding-left = 0
background = "ml4w.jpg"
use-background-color = false
background-color = "${BACKGROUND}"
blur = 32
brightness = -0.1
saturation = 0.8

[LockScreen.Clock]
display = true
position = "top-center"
align = "center"
format = "hh:mm AP"
font-family = "FiraSans Semibold"
font-size = 100
font-weight = 600
color = "${PRIMARY}"

[LockScreen.Date]
display = true
format = "dddd, MMMM dd, yyyy"
locale = "en_US"
font-family = "FiraSans Semibold"
font-size = 20
font-weight = 600
color = "${ON_SURFACE}"
margin-top = 10

[LockScreen.Message]
display = true
position = "bottom-center"
align = "center"
text = "Press any key to unlock"
font-family = "FiraSans Semibold"
font-size = 16
font-weight = 400
display-icon = true
icon = "enter.svg"
icon-size = 20
color = "${ON_SURFACE}"
paint-icon = true
spacing = 0

[LoginScreen]
background = "ml4w.jpg"
use-background-color = false
background-color = "${BACKGROUND}"
blur = 0
brightness = 0.0
saturation = 0.0

[LoginScreen.LoginArea]
position = "center"
margin = -1

[LoginScreen.LoginArea.Avatar]
shape = "circle"
border-radius = 60
active-size = 120
inactive-size = 100
inactive-opacity = 0.35
active-border-size = 2
inactive-border-size = 0
active-border-color = "${PRIMARY}"
inactive-border-color = "${PRIMARY}"

[LoginScreen.LoginArea.Username]
font-family = "FiraSans Semibold"
font-size = 20
font-weight = 600
color = "${ON_SURFACE}"
margin = 10

[LoginScreen.LoginArea.PasswordInput]
width = 250
height = 50
display-icon = true
font-family = "FiraSans Semibold"
font-size = 16
icon = "password.svg"
icon-size = 16
content-color = "${ON_SURFACE}"
background-color = "${SURFACE_CONTAINER}"
background-opacity = 0.8
border-size = 1
border-color = "${OUTLINE}"
border-radius-left = 12
border-radius-right = 12
margin-top = 10
masked-character = "●"

[LoginScreen.LoginArea.LoginButton]
background-color = "${PRIMARY}"
background-opacity = 0.8
active-background-color = "${PRIMARY}"
active-background-opacity = 1.0
icon = "arrow-right.svg"
icon-size = 18
content-color = "${ON_PRIMARY}"
active-content-color = "${ON_PRIMARY}"
border-size = 0
border-color = "${OUTLINE}"
border-radius-left = 12
border-radius-right = 12
margin-left = 5
show-text-if-no-password = true
hide-if-not-needed = false
font-family = "FiraSans Semibold"
font-size = 12
font-weight = 600

[LoginScreen.LoginArea.Spinner]
display-text = true
text = "Logging in"
font-family = "FiraSans Semibold"
font-weight = 600
font-size = 14
icon-size = 30
icon = "spinner.svg"
color = "${PRIMARY}"
spacing = 5

[LoginScreen.LoginArea.WarningMessage]
font-family = "FiraSans Semibold"
font-size = 20
font-weight = 400
normal-color = "${ON_SURFACE}"
warning-color = "${PRIMARY}"
error-color = "${ERROR}"
margin-top = 10

[LoginScreen.MenuArea.Buttons]
margin-top = 50
margin-right = 50
margin-bottom = 50
margin-left = 50
size = 30
border-radius = 12
spacing = 10
font-family = "FiraSans Semibold"

[LoginScreen.MenuArea.Popups]
max-height = 300
item-height = 30
item-spacing = 2
padding = 5
display-scrollbar = true
margin = 5
background-color = "${SURFACE_CONTAINER}"
background-opacity = 0.9
active-option-background-color = "${PRIMARY}"
active-option-background-opacity = 0.8
content-color = "${ON_SURFACE}"
active-content-color = "${ON_PRIMARY}"
font-family = "FiraSans Semibold"
border-size = 1
border-color = "${OUTLINE}"
font-size = 16
icon-size = 16

[LoginScreen.MenuArea.Session]
display = true
position = "bottom-left"
index = 0
popup-direction = "up"
popup-align = "center"
display-session-name = true
button-width = 300
popup-width = 300
background-color = "${SURFACE_CONTAINER}"
background-opacity = 0.0
active-background-opacity = 0.30
content-color = "${ON_SURFACE}"
active-content-color = "${PRIMARY}"
border-size = 0
font-size = 16
icon-size = 16

[LoginScreen.MenuArea.Layout]
display = true
position = "bottom-right"
index = 0
popup-direction = "up"
popup-align = "center"
popup-width = 180
display-layout-name = true
background-color = "${SURFACE_CONTAINER}"
background-opacity = 0.0
active-background-opacity = 0.30
content-color = "${ON_SURFACE}"
active-content-color = "${PRIMARY}"
border-size = 0
font-size = 10
icon = "language.svg"
icon-size = 20

[LoginScreen.MenuArea.Keyboard]
display = true
position = "bottom-right"
index = 0
background-color = "${SURFACE_CONTAINER}"
background-opacity = 0.0
active-background-opacity = 0.30
content-color = "${ON_SURFACE}"
active-content-color = "${PRIMARY}"
border-size = 0
icon = "keyboard.svg"
icon-size = 20

[LoginScreen.MenuArea.Power]
display = true
position = "bottom-right"
index = 0
popup-direction = "up"
popup-align = "center"
popup-width = 100
background-color = "${SURFACE_CONTAINER}"
background-opacity = 0.0
active-background-opacity = 0.30
content-color = "${ON_SURFACE}"
active-content-color = "${PRIMARY}"
border-size = 0
icon = "power.svg"
icon-size = 20

[LoginScreen.VirtualKeyboard]
scale = 1.0
position = "login"
start-hidden = true
background-color = "${BACKGROUND}"
background-opacity = 0.9
key-content-color = "${ON_SURFACE}"
key-color = "${SURFACE_CONTAINER}"
key-opacity = 0.8
key-active-background-color = "${PRIMARY}"
key-active-opacity = 1.0
selection-background-color = "${PRIMARY}"
selection-content-color = "${ON_PRIMARY}"
primary-color = "${PRIMARY}"
border-size = 1
border-color = "${OUTLINE}"

[Tooltips]
enable = true
font-family = "FiraSans Semibold"
font-size = 11
content-color = "${ON_SURFACE}"
background-color = "${SURFACE_CONTAINER}"
background-opacity = 0.8
border-radius = 5
disable-user = false
disable-login-button = false
EOF

# 5. /etc/sddm.conf 설정 적용
echo ":: 5. SDDM 전역 설정에 테마 및 가상 키보드 적용..."
if [ -f /etc/sddm.conf ]; then
    sudo cp -f /etc/sddm.conf /etc/sddm.conf.bak
    echo "   - 기존 설정을 /etc/sddm.conf.bak에 백업했습니다."
fi

sudo tee /etc/sddm.conf > /dev/null <<EOF
[Theme]
Current=ml4w

[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/ml4w/components/,QT_IM_MODULE=qtvirtualkeyboard
EOF

# 6. SDDM 서비스 활성화
echo ":: 6. SDDM systemd 서비스 활성화..."
sudo systemctl enable --force sddm

echo "=========================================================="
echo " 설치 및 테마 튜닝이 성공적으로 완료되었습니다!"
echo " 시스템을 재부팅하면 배경화면에 매칭되는 로그인 화면이 적용됩니다."
echo "=========================================================="

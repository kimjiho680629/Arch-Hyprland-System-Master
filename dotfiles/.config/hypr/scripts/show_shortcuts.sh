#!/usr/bin/env bash

files=(
    "$HOME/.config/hypr/conf/keybindings/default.conf"
    "$HOME/.config/hypr/conf/custom.conf"
)

# 파일 존재 여부 확인
valid_files=()
for f in "${files[@]}"; do [ -f "$f" ] && valid_files+=("$f"); done

# 고도화된 번역 및 카테고리화 로직
keybinds=$(awk -F'[=#]' '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    
    function get_info(d) {
        # 앱 실행
        if (d ~ /terminal/) return "🚀 [프로그램] 터미널 실행"
        if (d ~ /browser/) return "🌐 [프로그램] 브라우저 실행"
        if (d ~ /filemanager/) return "📂 [프로그램] 파일 관리자"
        if (d ~ /emoji/) return "😀 [프로그램] 이모지 선택기"
        if (d ~ /calculator/) return "🔢 [프로그램] 계산기 실행"
        
        # 창 관리
        if (d ~ /Kill active/) return "❌ [창 관리] 현재 창 닫기"
        if (d ~ /Fullscreen/) return "📺 [창 관리] 전체화면 전환"
        if (d ~ /Maximize/) return "🔲 [창 관리] 창 최대화"
        if (d ~ /floating/) return "☁️ [창 관리] 부동 모드 토글"
        if (d ~ /split/) return "✂️ [창 관리] 화면 분할 전환"
        if (d ~ /focus/) return "🎯 [창 관리] 포커스 이동"
        if (d ~ /resize/) return "📐 [창 관리] 창 크기 조절"
        
        # 시스템 및 스크린샷
        if (d ~ /Reload/) return "🔄 [시스템] 설정 새로고침"
        if (d ~ /screenshot/) return "📸 [시스템] 스크린샷 촬영"
        if (d ~ /Power Menu/) return "⚡ [시스템] 전원 메뉴"
        if (d ~ /Lock Screen/) return "🔒 [시스템] 화면 잠금"
        if (d ~ /launcher/) return "🔍 [시스템] 앱 검색/실행"
        if (d ~ /clipboard/) return "📋 [시스템] 클립보드 내역"
        if (d ~ /wallpaper/) return "🖼️ [시스템] 배경화면 변경"
        if (d ~ /theme/) return "🎨 [시스템] 테마/모드 전환"
        
        # 워크스페이스
        if (d ~ /workspace/) return "🗂️ [작업공간] 워크스페이스 이동/관리"
        
        # 미디어
        if (d ~ /volume|mute/) return "🔊 [미디어] 음량 조절"
        if (d ~ /brightness/) return "💡 [미디어] 밝기 조절"
        if (d ~ /Audio/) return "🎵 [미디어] 미디어 제어"
        
        return "✨ " d
    }

    BEGIN {
        num_patterns = 0
        patterns[++num_patterns] = "\\$mainMod"; replacements[num_patterns] = "윈도우"
    }

    $1 ~ /^bind[[:alpha:]]*/ {
        desc = ""
        if (match($0, /#[[:space:]]*(.*)$/, m)) desc = m[1]
        gsub(/^bind[[:alpha:]]*[[:space:]]*=+[[:space:]]*/, "", $0)
        rhs = trim($0)
        n = split(rhs, a, /[ 	]*,[ 	]*/)
        mods = trim(a[1]); key = (n >= 2 ? trim(a[2]) : "")
        for (i = 1; i <= num_patterns; i++) { gsub(patterns[i], replacements[i], mods) }
        gsub(/[ \t]+/, "+", mods)
        combo = (mods && key) ? toupper(mods) "+" toupper(key) : toupper(key ? key : mods)
        
        if (desc != "") {
            print "<b>" combo "</b>"
            print get_info(desc)
        }
    }
' "${valid_files[@]}")

# Yad 디자인 강화
echo "$keybinds" | yad --list \
    --title="ML4W 프리미엄 단축키 가이드" \
    --window-icon="preferences-desktop-keyboard-shortcuts" \
    --column="⌨️ 조합키:TEXT" --column="📝 기능 및 카테고리:TEXT" \
    --width=1100 --height=850 \
    --center \
    --search-column=2 \
    --markup \
    --editable=FALSE \
    --button="닫기:0" \
    --text="<span font='18' weight='bold' color='#3498db'> 💎 ML4W 전용 단축키 마스터 가이드 💎 </span>\n기능별 카테고리와 이모지를 통해 필요한 기능을 더 빠르게 찾으세요." \
    --separator="\n"

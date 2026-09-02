#!/usr/bin/env bash

# ==============================================================================
# 🚀 Arch-Hyprland-System-Master 스마트 GitHub 동기화 & CHANGELOG 자동 기록기
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

echo -e "${CYAN}================================================================${NC}"
echo -e "${GREEN}  🚀 Arch-Hyprland-System-Master GitHub 동기화 & 기록기  ${NC}"
echo -e "${CYAN}================================================================${NC}\n"

# 1. 시스템 최신 설정 실시간 동기화 (Sync from live system)
echo -e "${YELLOW}[1/5] 현재 시스템의 최신 설정 파일들을 저장소로 동기화 중...${NC}"
cp -rL ~/.config/hypr "$REPO_DIR/dotfiles/.config/" 2>/dev/null || true
cp -rL ~/.config/waybar "$REPO_DIR/dotfiles/.config/" 2>/dev/null || true
cp -rL ~/.config/fontconfig "$REPO_DIR/dotfiles/.config/" 2>/dev/null || true
cp -rL ~/.config/ml4w "$REPO_DIR/dotfiles/.config/" 2>/dev/null || true

cp -r /home/kjh/.local/bin/ai "$REPO_DIR/local-ai/" 2>/dev/null || true
cp -r /home/kjh/.local/bin/ask "$REPO_DIR/local-ai/" 2>/dev/null || true
cp -r /home/kjh/.local/bin/askweb "$REPO_DIR/local-ai/" 2>/dev/null || true
cp -r /home/kjh/.local/bin/asksys "$REPO_DIR/local-ai/" 2>/dev/null || true
cp -r /home/kjh/.local/bin/askqwq "$REPO_DIR/local-ai/" 2>/dev/null || true
echo -e "  ${GREEN}✓ 라이브 시스템 설정 동기화 완료${NC}\n"

# 2. 변경된 파일 상태 점검
MODIFIED_FILES=$(git status --porcelain)
if [ -n "$MODIFIED_FILES" ]; then
    echo -e "${BLUE}📁 [감지된 변경 파일 목록]:${NC}"
    git status --short
    echo ""
else
    echo -e "${YELLOW}ℹ️  현재 수정된 파일이 없으나, 업데이트 내역을 기록하여 푸시할 수 있습니다.${NC}\n"
fi

# 3. 업데이트 내용 입력받기
TITLE=""
DETAILS=""

if [ $# -gt 0 ]; then
    TITLE="$*"
else
    echo -e "${YELLOW}✏️  이번 업데이트의 [핵심 제목/한 줄 요약]을 입력하세요:${NC}"
    read -r -p "  제목 > " TITLE
    
    if [ -z "$TITLE" ]; then
        TITLE="시스템 설정 및 마스터 문서 동기화"
    fi

    echo -e "\n${YELLOW}📝 [상세 변경 내용]을 입력하세요 (엔터 시 완료, 없으면 그냥 엔터):${NC}"
    read -r -p "  상세 > " DETAILS
fi

CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 4. CHANGELOG.md 자동 업데이트
CHANGELOG_FILE="$REPO_DIR/CHANGELOG.md"
if [ -f "$CHANGELOG_FILE" ]; then
    echo -e "\n${YELLOW}[2/5] CHANGELOG.md에 변경 이력 자동 기록 중...${NC}"
    
    python3 -c "
import sys

title = sys.argv[1]
details = sys.argv[2]
date_str = sys.argv[3]
changelog_path = sys.argv[4]

new_entry = f'## 📌 [{date_str}] - {title}\n'
if details.strip():
    new_entry += '### 🌟 변경 내용\n'
    for line in details.strip().split('\n'):
        line = line.strip()
        if line:
            new_entry += (line if line.startswith(('-', '*')) else f'* {line}') + '\n'
else:
    new_entry += f'* {title}\n'

new_entry += '\n---\n\n'

try:
    with open(changelog_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if '---' in content:
        parts = content.split('---', 1)
        updated = parts[0] + '---\n\n' + new_entry + parts[1].lstrip('\n')
    else:
        updated = content + '\n\n' + new_entry

    with open(changelog_path, 'w', encoding='utf-8') as f:
        f.write(updated)
    print('  ✓ CHANGELOG.md 갱신 완료')
except Exception as e:
    print(f'  ⚠️ CHANGELOG 갱신 실패: {e}')
" "$TITLE" "$DETAILS" "$CURRENT_DATE" "$CHANGELOG_FILE"
fi

# 5. Git 스테이징 및 커밋
echo -e "\n${YELLOW}[3/5] 변경 사항 스테이징 중 (git add)...${NC}"
git add .

echo -e "\n${YELLOW}[4/5] Git 커밋 생성 중...${NC}"
if [ -n "$DETAILS" ]; then
    git commit -m "$TITLE" -m "$DETAILS" || echo "  • 새로운 커밋 내용 없음"
else
    git commit -m "$TITLE" || echo "  • 새로운 커밋 내용 없음"
fi

# 6. GitHub 원격 저장소 푸시
echo -e "\n${YELLOW}[5/5] GitHub 원격 저장소로 푸시 중 (git push)...${NC}"
if git push -u origin main; then
    echo -e "\n${GREEN}================================================================${NC}"
    echo -e "${GREEN}  🎉 GitHub에 전체 시스템 설정 및 업데이트가 성공적으로 반영되었습니다!  ${NC}"
    echo -e "${GREEN}================================================================${NC}"
    echo -e "  • ${CYAN}커밋 제목${NC}: $TITLE"
    [ -n "$DETAILS" ] && echo -e "  • ${CYAN}상세 내용${NC}: $DETAILS"
    echo -e "  • ${CYAN}반영 일시${NC}: $CURRENT_DATE"
    echo -e "  • ${CYAN}저장소 URL${NC}: $(git remote get-url origin 2>/dev/null || echo 'https://github.com/kimjiho680629/Arch-Hyprland-System-Master')\n"
else
    echo -e "\n${RED}⚠️ GitHub 푸시 중 오류가 발생했습니다.${NC}"
    echo -e "💡 저장소가 GitHub에 생성되어 있는지 확인해 주세요."
fi

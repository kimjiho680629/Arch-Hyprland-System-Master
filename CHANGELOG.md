# 📋 Arch-Hyprland-System-Master 변경 이력 (Changelog)

이 문서는 `Arch-Hyprland-System-Master` 프로젝트의 모든 주요 OS 설정, 닷파일 업데이트, 하드웨어 최적화 및 로컬 LLM 개선 내역을 시간순으로 기록하는 공식 변경 이력입니다.

---

## 📌 [2026-09-02] - v1.0.0: 최초 마스터 통합 릴리즈 (Initial Master Release)
### 🌟 주요 시스템 구축 내역
* **ML4W OS Dotfiles 최신 v2.15.1 갱신 및 다계층 영구 고정(Persistence Layer) 수립**:
  * 상하 듀얼 모니터 정밀 좌표계 (`3440x1440@100Hz` at `0x0` / `3840x2160@60Hz` at `440x1440`) 영구 보존.
  * Waybar 한영 입력 상태 이모지 국기(🇰🇷/🇺🇸) 매핑 및 Quickshell IPC 직결.
  * Fcitx5 한글 입력기 및 `fonts.conf` 한글 Regular(400) 가독성 고정.
* **Qwen 3.8 27B 기반 완전 자율형 로컬 AI 에이전트 및 CLI 스위트 구축**:
  * `ai` (자율 ReAct 에이전트), `ask`, `askweb` (Google RAG), `asksys` (하드웨어 진단), `qwq` (단계별 추론) 통합.
  * 하드웨어 3단계 티어(Tier 1/2/3) 실시간 자동 감지 엔진 및 0초 VRAM 즉시 반환(`keep_alive=0`) 최적화.
* **하드웨어 및 게이밍/전원 최적화**:
  * Ryzen 7 9800X3D + RTX 5070 Ti ReBAR, Direct Scanout, s2idle 현대적 절전 및 Wi-Fi 7 안정화 파라미터 내장.

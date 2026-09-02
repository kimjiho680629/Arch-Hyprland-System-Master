# 🚀 Arch Linux & Hyprland Complete System Master Suite
### (ML4W v2.15.1 + Dual Monitor + Korean Typography + Local AI ReAct Agent + Gaming Optimization)

본 저장소는 **Arch Linux (Hyprland / ML4W v2.15.1)** 환경에서 초고사양 하드웨어(Ryzen 7 9800X3D + RTX 5070 Ti)의 성능을 100% 끌어내고, **상하 듀얼 모니터 정밀 좌표계**, **한국어 폰트/입력기 완벽 최적화**, **Qwen 3.8 27B 기반의 완전 자율형 로컬 AI 에이전트 CLI 생태계**를 통합 관리할 수 있도록 구축된 올인원 마스터 시스템입니다.

---

## 📌 목차
1. [시스템 아키텍처 및 하드웨어 사양](#1-시스템-아키텍처-및-하드웨어-사양)
2. [저장소 디렉토리 구조](#2-저장소-디렉토리-구조)
3. [핵심 시스템 구성 요소 및 최적화](#3-핵심-시스템-구성-요소-및-최적화)
4. [로컬 LLM & 자율형 AI 에이전트 스위트 (`local-ai/`)](#4-로컬-llm--자율형-ai-에이전트-스위트-local-ai)
5. [원클릭 자동 설치 및 복원 방법](#5-원클릭-자동-설치-및-복원-방법)
6. [스마트 GitHub 업데이트 및 변경 이력 관리 (`update_github.sh`)](#6-스마트-github-업데이트-및-변경-이력-관리-update_githubsh)

---

## 1. 시스템 아키텍처 및 하드웨어 사양

* **운영체제 (OS)**: Arch Linux (Rolling Release, Linux 6.x Kernel)
* **윈도우 매니저 (WM)**: Hyprland (Wayland) + **ML4W OS Dotfiles v2.15.1**
* **프로세서 (CPU)**: AMD Ryzen 7 9800X3D (Zen 5 3D V-Cache, s2idle 현대적 절전)
* **그래픽카드 (GPU)**: NVIDIA GeForce RTX 5070 Ti 16GB GDDR7 (Resizable BAR ON, Direct Scanout)
* **디스플레이 (상하 듀얼 구성)**:
  * **상단 메인**: Cooler Master 34" WQHD (`3440x1440@100Hz`, `0x0`, 워크스페이스 `1~5`)
  * **하단 서브**: Dell 27" 4K UHD (`3840x2160@60Hz`, 1.5x 스케일, `440x1440` 중앙 정렬, 워크스페이스 `6~10`)
* **한국어 타이포그래피 & 입력기**: Fcitx5 한글 입력기, `fonts.conf` (한글 Regular 400 고정)
* **로컬 AI 스택**: Ollama (CUDA 가속, 0초 VRAM 즉시 반환, 주모델 `Qwen 3.8 27B`)

---

## 2. 저장소 디렉토리 구조

```
Arch-Hyprland-System-Master/
├── dotfiles/                        # Hyprland / Waybar / 폰트 등 핵심 설정
│   └── .config/
│       ├── hypr/                    # custom.lua, custom.conf, 듀얼 모니터 좌표계
│       ├── waybar/                  # 태극기/성조기 이모지 국기 매핑 & Quickshell IPC
│       ├── fontconfig/              # fonts.conf (한글 폰트 가독성 Regular 400 고정)
│       └── ml4w/                    # ML4W v2.15.1 관리 스크립트 및 버전 정의
├── local-ai/                        # 로컬 LLM & 자율형 에이전트 CLI 도구군
│   ├── ai                           # 완전 자율형 ReAct 에이전트 (터미널 제어 + 구글 검색)
│   ├── ask                          # 고속 단발 질의 및 파이프라인 분석
│   ├── askweb                       # Google 한국어 실시간 RAG 검색 CLI
│   ├── asksys                       # 1초 하드웨어 센서/로그 종합 진단 리포터
│   ├── askqwq                       # QwQ 32B 단계별 심층 추론 CLI
│   ├── install_all_local_llm.sh     # 범용 하드웨어 자동 감지 올인원 설치기
│   └── LOCAL_LLM_MASTER_GUIDE.md    # 로컬 AI 마스터 가이드 전문
├── docs/                            # 시스템/바이오스/게이밍 최적화 기술 문서
│   ├── bios_overclock_guide_9800x3d.md
│   ├── pch_fan_silence_guide.md
│   └── gaming_multitasking_optimization_guide.md
├── CHANGELOG.md                     # Semantic Versioning 프로젝트 변경 이력
├── update_github.sh                 # 스마트 GitHub 자동 동기화 스크립트
└── README.md                        # 본 마스터 안내서
```

---

## 3. 핵심 시스템 구성 요소 및 최적화

### 1) 상하 듀얼 모니터 정밀 좌표계 & 워크스페이스 영구 고정
* **오버라이드 레이어**: [`dotfiles/.config/hypr/custom.lua`](dotfiles/.config/hypr/custom.lua) 및 [`custom.conf`](dotfiles/.config/hypr/conf/custom.conf)
* **가로 중앙 정렬 수식**: 상단 WQHD(3440px) 대비 하단 4K(1.5배율 시 논리 2560px) 배치 시 $(3440-2560)/2 = \mathbf{440px}$ 오프셋을 적용하여 완벽한 인체공학적 대칭을 유지합니다.

### 2) Waybar 언어 모듈 및 한글 가독성
* **이모지 국기 매핑**: Fcitx5 입력 상태에 따라 투박한 한글/영문 텍스트 대신 태극기(🇰🇷) 및 성조기(🇺🇸) 아이콘으로 실시간 표시.
* **폰트 가독성 최적화**: [`dotfiles/.config/fontconfig/fonts.conf`](dotfiles/.config/fontconfig/fonts.conf)에서 `KoPubWorld` 한글 글꼴의 가중치(weight)를 `Regular(400)`으로 고정하여 흐릿함과 깨짐 현상을 원천 방지.

### 3) 게이밍 & 하드웨어 최적화
* **Direct Scanout & ReBAR**: 컴포지터 합성 과정을 우회하여 렌더링 레이턴시 최소화 및 16GB 전체 VRAM 대역폭 활용.
* **0초 VRAM 즉시 반환 (`keep_alive=0`)**: 로컬 AI 질의가 끝나면 즉시 GPU VRAM을 OS로 100% 반환하여 디아블로 4 등 고사양 게임과 무충돌 멀티태스킹 지원.

---

## 4. 로컬 LLM & 자율형 AI 에이전트 스위트 (`local-ai/`)

| 명령어 | 역할 및 특징 | 실행 예시 |
| :--- | :--- | :--- |
| **`ai`** | **[주모델: Qwen 3.8 27B]** 리눅스 셸 제어 + Google 검색을 스스로 수행하는 자율 ReAct 에이전트 | `ai "GPU 온도 확인하고 최신 뉴스 검색해줘"` |
| **`ask`** | 터미널 단발 질의 및 표준 입력 파이프라인 분석기 | `cat main.py \| ask "메모리 누수 검토해줘"` |
| **`askweb`** | Google 한국어 실시간 인덱스 기반 RAG 브리핑 | `askweb "오늘 원달러 환율 및 주요 경제 뉴스"` |
| **`asksys`** | 1초 만에 CPU/GPU 온도, VRAM, RAM, systemd, 커널 에러 종합 진단 | `asksys "지금 렉 걸릴 요인이 있는지 점검해줘"` |
| **`qwq`** | `<think>` 태그 기반 수학/알고리즘 단계별 심층 추론 | `qwq "이 알고리즘의 시간복잡도를 증명해줘"` |

---

## 5. 원클릭 자동 설치 및 복원 방법

새로운 Arch Linux 시스템에 본 환경 전체를 복원할 때는 아래 명령어를 순서대로 실행합니다:

```bash
# 1. 저장소 클론
git clone https://github.com/kimjiho680629/Arch-Hyprland-System-Master.git ~/Projects/Arch-Hyprland-System-Master

# 2. 닷파일 복원 심볼릭 링크 배포
cd ~/Projects/Arch-Hyprland-System-Master
cp -r dotfiles/.config/* ~/.config/

# 3. 로컬 LLM 및 자율형 에이전트 올인원 설치 실행
bash local-ai/install_all_local_llm.sh

# 4. Hyprland 갱신
hyprctl reload
```

---

## 6. 스마트 GitHub 업데이트 및 변경 이력 관리 (`update_github.sh`)

시스템 설정을 변경하거나 새로운 최적화를 추가했을 때는 터미널에서 스크립트 하나로 **`CHANGELOG.md` 자동 갱신 ➔ 커밋 ➔ GitHub 푸시**를 한 번에 진행할 수 있습니다:

```bash
cd ~/Projects/Arch-Hyprland-System-Master
./update_github.sh
```

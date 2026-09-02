# 게임 및 유튜브 동시 실행 시 온도 최적화 가이드

이 문서는 **Ryzen 7 9800X3D CPU**와 **RTX 5070 Ti GPU** 조합에서 게임 구동과 유튜브 동영상 시청을 동시에 진행할 때, 온도를 낮게 유지하면서 끊김(스터터링) 현상을 예방하기 위한 최적화 설정 가이드입니다.

---

## 1. CPU 최적화: PBO 온도 벽(Thermal Limit) 및 언더볼팅

Ryzen 9800X3D의 전압 마진을 확보하는 언더볼팅과 강제 온도 상한 설정을 조합하여 멀티태스킹 온도 스파이크를 원천 억제합니다.

### 1단계: Curve Optimizer & Curve Shaper (언더볼팅)
* **BIOS Tweaker -> Advanced CPU Settings -> Precision Boost Overdrive** 메뉴로 진입합니다.
* **Curve Optimizer**: `All Cores` / `Negative` / `15` ~ `20` 설정
* **Curve Shaper**: `Enabled` 후 다음 프로필 적용:
  * Low Temp (저온 / Idle 구간): `-5` ~ `-10`
  * Medium Temp (중온 / 로드 구간): `-12` ~ `-15`
  * High Temp (고온 / 풀로드 구간): `-10` ~ `-12`

### 2단계: PBO Platform Thermal Limit (온도 제한) 강제 적용
* **BIOS Precision Boost Overdrive** 내부 설정에서 **Platform Thermal Limit** 항목을 찾습니다.
* 설정을 **`Manual`**로 변경한 뒤, 값에 **`75`** 또는 **`80`**을 입력합니다.
* **의도**: CPU 온도가 75~80도에 도달하면 PBO 부스트 알고리즘이 클럭을 자동으로 제어해 발열을 억제합니다. 커스텀 수냉 환경에서는 성능 하락(1~2% 미만) 없이 온도 한계를 영구적으로 봉쇄하는 최선의 셋팅입니다.

---

## 2. GPU 최적화: 프레임 레이트 제한 및 VRAM 확보

유튜브(브라우저 하드웨어 가속)와 게임이 GPU 자원을 균형 있게 나눠 쓰도록 억제선을 설정하여 GPU 온도와 스터터링을 한 번에 제어합니다.

### 1단계: 인게임 최대 프레임 제한 (FPS Limiting)
* 게임 내 그래픽 설정(또는 MangoHud)에서 최대 프레임을 **모니터 주사율(100Hz)에 맞게 `100 FPS` 또는 G-Sync 안착을 위해 `97 FPS`로 강제 제한**합니다.
* **의도**: GPU가 모니터 한계를 넘어 불필요하게 100% 로드로 일하는 것을 방지하여 발열을 극적으로 하락시킵니다. (GPU 로드율 70~80% 대 진입 유도)

### 2단계: 그래픽 텍스처 옵션 조정
* 게임 내 텍스처 해상도/품질을 울트라(Ultra)에서 **`높음(High)`**으로 한 단계 조절합니다.
* **의도**: RTX 5070 Ti의 16GB VRAM 한도 도달로 인한 시스템 메모리(RAM) 스와핑 랙 및 이로 인한 CPU/GPU 오버헤드 증가를 방지합니다.

---

## 3. OS 및 브라우저 최적화 (Linux / Wayland)

유튜브 동영상 시청 시 CPU 연산 점유율이 튀는 것을 막고 GPU의 하드웨어 디코더(NVDEC)가 전담하도록 설정합니다.

### 1단계: 웹 브라우저 비디오 하드웨어 가속 (VA-API) 활성화
* Chrome/Brave/Edge 주소창에 `chrome://flags` 입력 후 **`Hardware-accelerated video decode`**를 **`Enabled`**로 변경합니다.
* 브라우저 시작 옵션(또는 `~/.config/chrome-flags.conf`)에 다음 플래그가 주입되었는지 확인합니다:
  ```text
  --enable-features=VaapiVideoDecoder
  --use-gl=angle
  --ozone-platform=wayland
  ```
* **의도**: AV1 / VP9 코덱의 비디오 디코딩 처리를 CPU 소프트웨어 렌더링 대신 GPU 하드웨어 가속 칩셋으로 완전히 이관하여 CPU 발열을 최소화합니다.

### 2단계: Hyprland direct_scanout 유지
* `hyprland.conf` (또는 `custom.conf`) 내에 `render:direct_scanout = true`가 켜져 있는지 확인합니다.
* **의도**: 게임 렌더링 시 컴포지터 합성 과정을 바이패스하여 윈도우 매니저 자체의 오버헤드를 감소시키고 그래픽 카드의 온도를 낮춥니다.

# Gigabyte B850I AORUS PRO & Ryzen 7 9800X3D 바이오스 오버클럭 가이드

이 문서는 **Ryzen 7 9800X3D CPU**와 **Gigabyte B850I AORUS PRO 메인보드** 조합에서 **커스텀 수냉 쿨러** 환경을 활용한 최적의 실사용 오버클럭(PBO + Curve Optimizer + Curve Shaper) 설정 가이드입니다.

---

## 💻 시스템 기본 사양
- **CPU**: AMD Ryzen 7 9800X3D (8 Cores / 16 Threads, Zen 5 아키텍처, 3D V-Cache 탑재)
- **Motherboard**: Gigabyte B850I AORUS PRO (Mini-ITX, 고품질 전원부)
- **Cooling**: 커스텀 수냉 (Custom Water Cooling) - 매우 여유로운 온도 마진 확보

---

## 🛠️ BIOS 설정 가이드

### 1단계: BIOS 진입 및 기본 설정
1. PC 전원을 켠 후 즉시 키보드의 **[Delete]** 키를 연속하여 눌러 BIOS 설정 화면으로 진입합니다.
2. 메인 화면이 Easy Mode로 되어 있다면, 키보드의 **[F2]** 키를 눌러 **Advanced Mode (고급 모드)**로 전환합니다.

### 2단계: 메모리 EXPO (메모리 오버클럭) 활성화
3D V-Cache는 메모리 성능 민감도를 완화하지만, 1% Low 프레임 하락 방지 및 미세한 스터터링 억제를 위해 필수적인 단계입니다.
1. 상단 메뉴에서 **[Tweaker]** 탭으로 이동합니다.
2. **Extreme Memory Profile (X.M.P.) / AMD EXPO** 설정을 찾아서 **[Profile 1]** 또는 **[Enabled]**로 변경합니다.
3. *권장사항*: Zen 5 프로세서에서는 1:1 동기화 기준으로 DDR5 6000MHz ~ 6400MHz 대역이 골디락스 존(가장 안정적이고 효율적임)입니다.

### 3단계: PBO (Precision Boost Overdrive) 활성화
9800X3D는 고정 배수 수동 오버클럭보다 온도/전력 마진을 자동 감지해 단일/멀티 부스트 클럭을 최대로 끌어올리는 PBO 방식이 훨씬 효율적입니다.
1. **[Tweaker]** 탭 -> **[Advanced CPU Settings]** -> **[Precision Boost Overdrive]** 항목으로 이동합니다.
   - *또는 **[Settings]** 탭 -> **[AMD Overclocking]** -> **[Precision Boost Overdrive]** 경로 이용.*
2. **Precision Boost Overdrive**: **[Advanced]**로 설정합니다.
3. 이하 세부 매개변수를 조정합니다:
   - **PBO Limits**: **[Motherboard]** 또는 **[Manual]** 설정
     - *커스텀 수냉 쿨링 환경이므로 메인보드 전력 한도([Motherboard])를 인가하여 마진을 최대로 확보합니다.*
     - *수동 수치(Manual)를 선호할 시 추천 가이드: PPT `140W` / TDC `120A` / EDC `160A` (9800X3D 최적 스윗스팟)*
   - **Precision Boost Overdrive Scalar**: **[Manual]** 설정 후 **[10X]**로 변경하여 전압 유지 한계를 해제합니다.
   - **Max CPU Boost Clock Override**: **[Enabled (Positive)]** 설정 후 **[+150MHz]** 또는 **[+200MHz]** 추가.
     - 기본 최대 부스트인 5.2GHz에 추가 마진을 가해 작업 조건이 맞으면 최대 5.35 ~ 5.4GHz 도달을 유도합니다.

### 4단계: Curve Optimizer (언더볼팅)
동일 주파수에서 동작 전압을 낮춰(언더볼팅) 발열량을 낮추고 부스트 클럭 유지 성능을 향상시킵니다.
1. PBO 메뉴 하단의 **[Curve Optimizer]** 항목으로 진입합니다.
2. 설정을 다음과 같이 조정합니다:
   - **Curve Optimizer**: **[All Cores]** 선택
   - **All Core Curve Optimizer Sign**: **[Negative]** (전압 하향 설정)
   - **All Core Curve Optimizer Magnitude**: **[15]**에서 **[20]** 사이 입력 (안전 마진 중심 실사용 추천값)
     - *처음에는 `15`로 세팅하여 안정성을 점검하고, 문제가 없다면 `20`으로 단계적 하향 조정합니다.*

### 5단계: Curve Shaper (Zen 5 전용 고급 전압 미세 조정)
Zen 5 아키텍처에 추가된 기술로 온도(Low/Medium/High) x 부하량(Minimum/Low/Medium/High/Max)의 15개 영역별 전압을 정밀 튜닝합니다. 이를 통해 저부하 상태에서의 프리징/블루스크린과 고부하 상태의 셧다운 문제를 완전히 해결할 수 있습니다.
1. PBO 메뉴 내부의 **[Curve Shaper]** 항목을 **[Enabled]**로 변경합니다.
2. 안정성이 확인된 세부 전압 오프셋 값(추천 프리셋)을 입력합니다:
   - **Low Temp (저온) / Idle & Low Load**: **[-5]** ~ **[-10]** 설정 (부팅 초기에 전압 강하로 인한 다운 방지)
   - **Medium Temp (중온) / Medium & High Load**: **[-12]** ~ **[-15]** 설정 (일반 게임 및 멀티태스킹 동작 구간)
   - **High Temp (고온) / Max Load**: **[-10]** ~ **[-12]** 설정 (풀로드 시 연산 누락 및 코어 셧다운 방지)
   - *이 값들은 Curve Optimizer 오프셋에 대해 추가로 작용하는 스케일러 역할을 수행합니다.*

### 6단계: 저장 및 재부팅
1. 키보드의 **[F10]** 키를 누릅니다.
2. 변경 내역 리스트를 마지막으로 점검한 후 **[Yes]** 또는 **[Save & Exit]**를 눌러 설정을 저장하고 시스템을 리부팅합니다.

---

## 🔬 전문가적 견해 (Expert Insight)

### PBO + Curve Shaper 튜닝의 메커니즘과 강점
1. **3D V-Cache 적층 구조 보호**:
   Ryzen 7 9800X3D는 실리콘 다이 위에 추가 캐시 메모리가 얹어진 독특한 3D 적층형 설계입니다. 이로 인해 열 저항이 일반 칩셋보다 크며, 수동으로 1.35V 이상의 전압을 가하는 배수 고정 오버클럭 시 코어 손상이 발생하기 매우 쉽습니다. 전압 오프셋(CO) 및 Curve Shaper를 통한 언더볼팅 기반의 클럭 유지가 정답인 이유입니다.
2. **커스텀 수냉 쿨링의 이점 극대화**:
   커스텀 수냉의 강력한 쿨링력(수온 유지 성능)은 CPU의 실시간 온도 한계선 도달 시점을 늦추어 줍니다. PBO가 실시간으로 온도를 계산해 부스트 클럭을 인가하므로, 수냉 쿨러 환경 하에 셋팅된 PBO는 일반 공랭 쿨러 시스템보다 부스트 유지율 및 최고 부스트 지속 시간이 훨씬 늘어납니다.
3. **Curve Shaper가 해결하는 실사용 안정성 붕괴**:
   기존 Zen 4 아키텍처에서는 올코어 Negative `-30`을 먹여 시네벤치 등 고부하 툴은 무사히 통과하였으나, 아이들(컴퓨터를 가만히 둘 때)이나 단순 웹서핑 중 시스템이 먹통이 되는 저전력/저부하 에러가 고질적으로 발생했습니다. Curve Shaper는 온도 및 부하 대역에 따라 유연하게 전압 깎기 비율을 지정할 수 있으므로, 저부하 시에는 전압 마진을 넉넉히 남기고 고부하 구간에서만 전압 다이어트를 실행해 안정성과 성능을 모두 보존합니다.

---

## 🧪 안정성 테스트 프로토콜
성능 향상을 확인하고 실사용 오류를 방지하기 위해 다음 테스트 과정을 단계적으로 거치십시오.

1. **온도 및 기본 안정성**: **Cinebench 2024 / R23** (10분 테스트 진행하여 최대 온도가 85도 미만으로 방어되는지 확인)
2. **언더볼팅 연산 오류 검증**: **OCCT (CPU Test - SSE/AVX)** 또는 **Prime95 (Small FFTs)** 최소 30분 구동
3. **실사용 전환**: 실제 3D 고사양 게임(예: 디아블로 4 등)을 1시간 이상 플레이하며 강제 종료 여부 확인

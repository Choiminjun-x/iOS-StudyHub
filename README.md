## iOS-StudyHub

개인 정리 + 공개용 iOS 학습 저장소입니다. UIKit, SwiftUI, Web, Media, 아키텍처(RIBs) 등 다양한 주제를 실습 코드 중심으로 축적합니다. README는 개요/구조/가이드 위주로 유지하며, 구체 예제 목록은 따로 나열하지 않습니다.

### 요구 사항
- Xcode 15 이상 권장
- iOS 15 이상 시뮬레이터/디바이스
- CocoaPods 설치(`pod --version`으로 확인)

### 실행 방법
1) 의존성 설치
   - `pod install`
2) 워크스페이스 열기
   - `open iOS-StudyHub.xcworkspace`
3) 실행
   - Scheme: `iOS-StudyHub`
   - Target 디바이스 선택 후 실행(⌘R)

### 예제 탐색 방법
- 앱을 실행하면 메인 화면에서 학습 항목 목록을 확인할 수 있습니다.
- 각 항목은 해당 예제 화면으로 이동하며, 관련 소스는 `Pages/` 하위 디렉터리에 위치합니다.

### 프로젝트 구조
- `Application/` 앱 진입(AppDelegate, SceneDelegate) 및 윈도우 구성
- `Pages/` 주제별 예제 화면 모음
  - `SwiftUI+UIKit/` 하이브리드 구성 예제
  - `UIKit/` UIKit 기반 컴포넌트/패턴 예제
  - `Web & Browser/` 웹/인앱 브라우저 연동 예제
  - `Media & Camera/` 카메라/미디어 관련 예제
  - `Architecture/RIBs/` 아키텍처 관련 예제
- `Resources/` 에셋/리소스
- `SupportingFiles/` 설정 파일 등 보조 리소스
- `Utils/` 공용 유틸리티(`Sets.swift` 등)

### 메인 화면 구성
- `Pages/Main/MainViewController.swift`
  - 학습 항목 리스트를 표시하고, 선택 시 각 예제 화면으로 이동합니다.

### 스크린샷/GIF(선택)
- `Resources/Screenshots/` 폴더에 화면별 스크린샷을 추가하고, 아래처럼 README에 첨부하세요.
  - 예) `![Dashboard](Resources/Screenshots/dashboard.png)`

### 주제 추가 가이드
1) 예제 화면 생성
   - 새 `ViewController`(또는 SwiftUI `View`)를 `Pages/<Category>/<Topic>/`에 추가
2) 라우팅 연결
   - `MainViewController`의 `studyMenuItems`에 항목 추가(타이틀/설명/카테고리/화면)
3) 의존성 필요 시
   - `Podfile`에 라이브러리 추가 → `pod install`
4) 문서화(선택)
   - README에는 예제 목록을 추가하지 않습니다. 필요 시 해당 디렉터리에 소규모 `README.md` 또는 코드 주석으로 정리합니다.

### 문서 운영 원칙
- README는 개요/실행/구조/가이드 중심으로 유지합니다.
- 예제 목록은 앱 내 메인 화면에서 확인합니다(README에 개별 나열하지 않음).
- 변경은 작은 단위로 나누어 반영하고, 불필요한 문서 갱신 비용을 줄입니다.

### 로드맵(예시)
- Networking(Concurrency/Combine) 샘플 추가
- 데이터 영속화(Core Data/Realm) 예제
- 테스트(Unit/UI Test) 샘플 추가
- 접근성/국제화 적용 사례

---
문의/피드백 환영합니다. 개선 사항이나 아이디어가 있다면 이슈나 PR로 남겨주세요.

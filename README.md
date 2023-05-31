# pet_mobile_social_flutter

Pet Social 프로젝트

# Environment

- Flutter (stable)
    - Flutter 3.7.x
    - Dart 3.0.x
    - Devtools 2.23.x
- Android
    - minSdkVersion 19
    - targetSdkVersion 33
    - compileSdkVersion 33
- iOS
    - CocoaPods version 1.11.3
    
* Dependencies
    <details>
    <summary>dependencies</summary>

        cupertino_icons: ^1.0.2
        retrofit: ^4.0.1
        riverpod: ^2.3.6
        go_router: ^7.1.1
        freezed: ^2.3.4
        freezed_annotation: ^2.2.0
        json_annotation: ^4.8.1
        flutter_screenutil: ^5.8.3
        flutter_dotenv: ^5.0.2
    </details>

    <details>
    <summary>dev_dependencies</summary>

        flutter_lints: ^2.0.0
        build_runner: ^2.4.4
        json_serializable: ^6.7.0
        freezed: ^2.3.4
    </details>
    
    

# Build Guide

- 해당 프로젝트 clone 후, `flutter pub get`로 플러그인들을 사용할 수 있게 프로젝트로 가져와서 사용
- 최초 Build 시 아래 명령 실행
    - build_runner
        - 여러 Model을 위해 build_runner 사용
        - `-delete-conflicting-outputs` 옵션은 입력 안해도 무방
        
        ```
        flutter pub run build_runner build --delete-conflicting-outputs
        ```
        

### apk 추출

- `flutter build apk` 를 통해 apk를 추출 할 수 있습니다.
- 추출 후 `build/app/outputs/apk/release` 에서 추출된 apk 확인이 가능

### App Bundle 추출

- `flutter build appbundle` 를 통해 appbundle를 추출 할 수 있습니다.
- 추출 후 `build/app/outputs/bundle/release` 에서 추출된 appbundle 확인이 가능

## Git Flow Rules

- 한번 커밋은 하나의 기능 개발을 목표로 한다.
- 상대방에게 코드리뷰를 부탁하고 develop branch 로 merge
    - 개인 branch 에서 develop branch 로는 squash merge
    - develop branch 에서 master branch 는 create merge
- 작업 하기전 issue를 올려 작업할 일 체크 및 확인

- main : 제품으로 출시될 수 있는 브랜치
- develop : 다음 출시 버전을 개발하는 브랜치
- feature : 기능을 개발하는 브랜치
    - 기능/이니션-개발내용을 develop branch 기준으로 분기합니다.
        - ex ) feature/jgw-login-screen

```
main → release 시 tag 붙여서 진행, 배포시

develop → 개발버전, 최신, 배포되면 main PR

feature → 기능개발, develop PR, 머지지고 완료되면 삭제

hotfix → 필요시, main PR, 머지지고 완료되면 삭제
```

# App Description

**File Structure**

riverpod 상태관리 패키지를 사용하며 mvvm 디자인 패턴을 채택하여 프로젝트를 구성 할 계획

- assets : images, font  등의 앱에서 사용할 design asset
- config : 앱의 **전반적** 구성요소들
    - theme : theme 요소 및 theme 관리 데이터
    - route : 라우팅 소스
- data : data layer 관련 요소들
    - local: 로컬에 저장된 정보를 가져오는 모든 함수들이 구현
    - remote: API서버와 통신에 필요한 모든 함수들이 구현
- model : data폴더의 model과 달리 데이터 파싱, 변환에 영향을 받지않는 근본적인 데이터 구조를 나타내는 클래스 or  데이터 관련 클래스(DTO)
- repositories : 레포지토리 구현체 및 인터페이스.
- ui : 사용자가 직접 확인이 가능한 하는 화면
- component : 공통된 위젯 컴포넌트
- viewmodel : View상태를 유지/관리하는 곳

---

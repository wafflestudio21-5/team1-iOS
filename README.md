# team1-iOS

- 프로젝트 파일 생성 방법
  - Tuist 설치 (Tuist 없다면)
    ```
      curl -Ls https://install.tuist.io | bash
    ```
  - 설치 확인
    ```
      tuist version 
    ```
    - 버전 나오면 제대로 설치된 것
    - 노란색 warning은 무시
- watomate 폴더(Project.swift 파일 있는 폴더) 내에서
  - 외부라이브러리 가져오기
    ```
      tuist fetch 
    ```
  - 프로젝트 파일 생성
    ```
      tuist generate 
    ```

- 카카오 앱키 추가하기
  - Derived/InfoPlists/Watomate-Info 안에 들어가기
      ![image](https://github.com/wafflestudio21-5/team1-iOS/assets/86519350/ac86e360-5ade-4578-b0a1-9199dc4efc64)

  - URL Schemes 안에 kakao 찾아서 kakao 뒤에 앱키 붙여넣기
      ![image](https://github.com/wafflestudio21-5/team1-iOS/assets/86519350/5184c88f-4f32-4205-8030-a3b939097fd4)

  - 예) 앱키 1234면 kakao1234
 
  - 다시 run..? (tuist fetch, tuist generate X)

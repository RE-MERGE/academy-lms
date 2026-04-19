# 🎓 RE-MERGE LMS
> Java Spring 기반 학사 관리 시스템 (Learning Management System)

## 🛠 Tech Stack
| 분류 | 기술 |
|------|------|
| Language | Java 17 |
| Backend | Spring Framework |
| Frontend | JSP, JavaScript (Fetch API) |
| Database | MariaDB 11.7.2 |
| Build | Maven |

---

## 📋 협업 규칙 (Commit Convention)
| 태그 | 설명 | 예시 |
|------|------|------|
| `feat` | 새로운 기능 추가 | `feat: 로그인 기능 구현` |
| `fix` | 버그 수정 | `fix: 회원가입 유효성 검사 수정` |
| `edit` | 기존 코드 수정 및 로직 변경 | `edit: 대시보드 조회 로직 최적화` |
| `style` | UI/UX 디자인 및 CSS 수정 | `style: 사이드바 디자인 변경` |
| `docs` | 문서 수정 (README, 설계서 등) | `docs: 설계서 링크 업데이트` |
| `chore` | 빌드 설정 및 라이브러리 관리 | `chore: pom.xml 의존성 추가` |

---

## 🔀 Workflow
1. **Branch:** 본인 이름으로 된 브랜치에서 작업합니다.
2. **Push:** 기능 구현 완료 후 본인 원격 브랜치에 `Push`를 진행합니다.
3. **Merge:** GitHub에서 `Pull Request(PR)`를 생성하며, `main` 브랜치에 최종 병합합니다.

---

## ⚙️ Development Setup
### 1. MariaDB Connection
- **DB Name:** `academy_lms`
- **Port:** `9712`

---

## 📂 Project Documents
프로젝트의 기획 및 상세 설계 단계에서 작성된 주요 문서입니다.

| 구분 | 문서명 | 링크 |
| :--- | :--- | :--- |
| **기획** | 요구사항 분석서 | [requirements-analysis.pdf](./docs/requirements-analysis.pdf) |
| **설계** | UI/UX 화면 설계 및 기능 분석 | [LMS_Final_Design.pdf](./docs/LMS_Wireframe.pdf) |
| **DB** | ERD 설계도 | [erd.png](./docs/erd.png) |

---
# 랭킹스타 (Ranking Star)

## 프로젝트 개요
- **랭킹스타**는 실시간 유저 랭킹 기능을 제공하는 SNS 앱입니다. 이 앱은 카카오 소셜 로그인, 실시간 랭킹 갱신, 마이페이지 관리 등 다양한 기능을 포함하고 있습니다. 
- 해당 프로젝트는 **네이티브 앱**에서 **PHP 기반 웹 애플리케이션**으로 변환하여 개발되었습니다.

## 기술 스택
| 파트       | 기술                                                   |
|------------|--------------------------------------------------------|
| Backend    | PHP, Apache                                            |
| Database   | MySQL (phpmyadmin 사용)                                 |
| Frontend   | HTML, CSS, JavaScript                                  |
| DevOps     | Apache Web Server, PHPmyAdmin, GitHub (버전 관리)       |
| 인증       | 카카오 OAuth2                                          |

## 주요 기능
- **소셜 로그인**: 카카오 OAuth2를 통한 간편한 로그인
- **실시간 유저 랭킹 표시**: 실시간으로 업데이트되는 유저 랭킹
- **마이페이지**: 유저가 본인의 정보를 수정/조회할 수 있는 페이지
- **관리자 통계**: 관리자 페이지를 통해 유저 통계 및 랭킹 관리

## 담당 역할
- 백엔드 API 설계 및 구현
- 카카오 OAuth2 인증 연동
- 실시간 랭킹 계산 로직 및 비동기 처리 설계
- MySQL 데이터베이스 스키마 설계 및 쿼리 최적화

## 프로젝트 구조
rankingstar/
├── application/ # 애플리케이션 관련 파일
├── assets/ # CSS, JavaScript, 이미지 파일
├── phpmyadmin/ # phpMyAdmin 관련 파일
├── resources/ # 리소스 파일
├── shopping_/ # 쇼핑 관련 파일
├── sqladmin/ # SQL 관리자 파일
└── index.php # 메인 파일

## 개발 기간
- **개발 기간**: 2025.03 ~ 2025.07
- **팀 구성**: 총 3명 (백엔드 담당)

## 📎 기타
- PHP 7.x
- Apache 2.4 이상
- MySQL 5.x 이상

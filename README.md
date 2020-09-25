# portable_sipenv
社会情報学メジャー用Javaプログラミング環境(Windows-x64)構築スクリプト

JDK + Eclipse + Pleiades + etc.
- AdoptOpenJDK: https://adoptopenjdk.net/
- Eclipse: https://www.eclipse.org/downloads/eclipse-packages/
- Pleiades: http://mergedoc.osdn.jp/
- PortableGit: https://git-scm.com/, https://github.com/git-for-windows/git/releases/

## バージョン番号

X.YpZ
- X: メジャーバージョン（ディレクトリ構成の変更，CLI環境の設定変更など）
- Y: マイナーバージョン（JDKのメジャーバージョンの変更）
- Z: パッチレベル（上記以外の更新）

リリース
| バージョン | リリース日 | JDK | Eclipse | Git |
|:---|:---|:---|:---|:---|
| 3.0p2 | 2020/09/25 | 11.0.8_10 | 2020-09-R | 2.28.0 |
| 3.0p1 | 2020/06/27 | 11.0.7_10 | 2020-06-R | 2.27.0 |
| 3.0   | 2020/04/30 | 11.0.7_10 | 2020-03-R | 2.26.2 |

## ディレクトリ構成
```
portable_sipenv
   +-- Makefile        (構築スクリプト本体)
   +-- eclipseconf.sh  (Eclipse設定用シェルスクリプト)
   +-- javaenv.src     (javaenv.batのソース)
   +-- jclinit.src     (jclinit.batのソース)
   +-- work   (作業用ディレクトリ - アーカイブ展開用)
   +-- sipenv (作業用ディレクトリ - 環境出力用)
distfiles  (ダウンロードファイル - 構築スクリプトから使用)
   +-- eclipse-java-yyyy-xx-R-win32-x86_64.zip
   +-- MinGit-x.xx.x-64-bit.zip
   +-- OpenJDKxxU-jdk_x64_windows_hotspot_xx.x.x_x.zip
   +-- pleiades-win-yyyymmdd.zip
release  (成果物用ディレクトリ)
   +-- sipenv-x.x.yyyymmdd.zip
```

## How to make
```
$ make
```

## How to install
- `sipenv-x.x.yyyymmdd.zip`をCドライブの直下（C:\）に展開する
- Windows標準のエクスプローラーでは展開に時間がかかる
- 7-Zipで展開できることを確認済み

## 展開後のディレクトリ構成
```
sipenv
   +-- eclipse
   |      +-- eclipse.exe  (Pleiades plugin適用済みEclipse)
   +-- java
   |      +-- 11  (AdoptOpenJDK 11)
   +-- PortableGit
   +-- work
   +-- workspace
   +-- Java command-line.lnk  (cmd.exeへのショートカット)
   +-- javaenv.bat  (JDK切り替え用バッチファイル)
   +-- jclinit.bat  (cmd.exeのPathを設定するバッチファイル)
   +-- version.txt
```

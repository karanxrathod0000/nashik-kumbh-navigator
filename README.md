# Nashik Kumbh Navigator — Simhastha 2027 Official Pilgrim & Volunteer App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Release](https://img.shields.io/badge/Release-v1.0.0-FF8C42?logo=github)](https://github.com/karanxrathod0000/nashik-kumbh-navigator/releases/latest)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-4CAF50?logo=android)](https://github.com/karanxrathod0000/nashik-kumbh-navigator/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Official navigation and civic safety application for **Nashik Kumbh Mela Simhastha 2027** pilgrims, volunteers, and emergency response teams. Built with Flutter, Riverpod, Google Maps Platform, and Firebase.

---

## 📲 Download & Install (Direct APK)

1. Download the latest APK: [NashikKumbhNavigator-v1.0.0.apk](https://github.com/karanxrathod0000/nashik-kumbh-navigator/releases/latest)
2. On your Android phone, tap the downloaded file.
3. If prompted **"Install blocked"** or **"Install unknown apps"**, tap **Settings** → enable **Allow from this source** → go back and tap **Install**.
4. Open the app and choose **Continue as Guest** for instant access, or sign in with Google/Phone for saved places and personalized alerts.

> [!IMPORTANT]
> This direct APK is provided for volunteers, officials, and early testers ahead of official app store listings on **Amazon Appstore** and **Samsung Galaxy Store**.

### 🔗 Field Scan & Short Link
Pilgrims and volunteers at Nashik railway stations, Sadhugram entry gates, and help desks can scan the printed poster QR code:
* **Short Field Download Link**: `https://is.gd/kumbh_navigator_apk`
* **Poster QR Code Asset**: [`dist/bin/kumbh_navigator_download_qr.png`](file:///c:/Users/karan/OneDrive/Desktop/projects/Nashik%20Kumbh%20Mela%20Navigation/dist/bin/kumbh_navigator_download_qr.png)

---

## ✨ Key Features

* **🗺️ Live Crowd-Aware Navigation**: Turn-by-turn walking and shuttle routes across Ramkund, Kushavarta Ghat, Sadhugram sectors, and Trimbakeshwar.
* **🔥 Real-Time Crowd Density Heatmaps**: Dynamic color-coded zones (Green / Yellow / Red) routing pilgrims away from high-density bottleneck corridors.
* **🚨 One-Tap SOS 108 Emergency Command**: Instant GPS coordinates dispatch to Maharashtra Police (100), Medical Emergency (108), and Disaster Management Control Room (1070).
* **🪔 Shahi Snan Bathing Muhurat Timers**: Accurate schedules, auspicious bathing muhurats, and live crowd predictions for the Three Royal Snan dates.
* **🌐 Multilingual Localization**: Full support for English, Hindi (हिन्दी), and Marathi (मराठी).
* **📶 Offline-First Resilience**: Cached sector directories and emergency help lines accessible even during cellular network congestion.

---

## 🛠️ Technology Stack

* **Frontend Framework**: Flutter 3.x (Dart 3)
* **State Management**: Riverpod (`flutter_riverpod`)
* **Mapping & GIS**: Google Maps Flutter SDK + Custom Overlay Polylines
* **Backend & Real-Time Sync**: Firebase Cloud Firestore, Firebase Authentication, Cloud Messaging
* **Release Engineering**: R8 / ProGuard Minified, RSA 2048-bit Signed Multi-ABI & Universal APKs compliant with Android 14+ (API 34/35) and 16KB memory page size.

---

## 🔄 Ongoing Update Workflow

Since direct APK distributions do not update automatically through an app store:
1. Every new release bumps `versionCode` and `versionName` (e.g., `v1.0.1`).
2. The app includes an integrated **GitHub Release Update Checker** (`UpdateCheckerService`) that pings the official GitHub API (`https://api.github.com/repos/karanxrathod0000/nashik-kumbh-navigator/releases/latest`) and notifies guest or sideloaded users when a new APK is ready to install.
3. The latest release link above permanently resolves to the newest available release binary.

---

## 🏛️ Community & Transparency Note

This repository is maintained as an open civic project for pilgrim safety and seamless navigation during **Simhastha 2027**. All production secrets, signing keystores, and API keys are strictly excluded from version control (`.gitignore`). Contributors should copy `.env.example` to `.env` to configure local development environments.

---
*Nashik Kumbh Mela Navigation Project — Simhastha 2027*

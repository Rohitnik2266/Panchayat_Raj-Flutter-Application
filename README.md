# 🌾 Panchayat Raj Services App (Demo Version)

This is a **demo Flutter application** designed to digitally empower rural citizens by providing easy access to government welfare schemes.  
While this project does **not** use real government APIs, it demonstrates the full functionality, user flow, and interface of what a real integrated system could look like.

---

## 📌 About the Demo

> ⚠️ This is a **demo version** for educational and prototype purposes.  
> A real-world deployment would:
> - Use **official government APIs**
> - Be connected to **secure government databases**
> - Include **real-time validation and automated approvals**
> - Be **more robust, secure, and scalable**

However, this demo already covers:
✅ OTP login  
✅ Scheme viewing  
✅ Form submission with apply/refill logic  
✅ Firebase backend  
✅ Dark/light theme  
✅ Multilingual support  

---

## 🚀 Features

- ✅ List of 15+ government schemes
- 📝 Scheme-specific forms with field validation and file upload
- 🔒 OTP-based phone login using Firebase Auth
- ☁️ Firebase Firestore to store user-submitted forms
- 📁 File upload (like Aadhar, certificates)
- 🌗 Dark/Light theme toggle
- 🌐 Multilingual UI (English, मराठी, ಕನ್ನಡ)
- 🔁 Apply once, refill only if allowed

---

## 🛠 Tech Stack

- Flutter 3.x
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Dart Intl / `.arb` files for localization
- Provider for theme and language management

---

## 📂 Key Folder Structure

```plaintext
lib/
├── screens/       # Login, OTP, Profile, etc.
├── schemes/       # 15+ Scheme Info Pages
├── forms/         # 15+ Scheme Form Pages
├── l10n/          # .arb files for i18n (EN, MR, KN)
└── firebase_options.dart (excluded from Git)
🧪 How to Run the Project
⚠️ Firebase credentials are excluded for security. Set up your own Firebase project.

1. Clone this repo
bash
Copy
Edit
git clone https://github.com/your-username/panchayat-raj-app.git
cd panchayat-raj-app
2. Add Firebase Configuration
Go to Firebase Console

Set up Android/iOS app

Add:

google-services.json → android/app/

GoogleService-Info.plist → ios/Runner/

Run:

flutterfire configure
This will generate lib/firebase_options.dart.

3. Run the App

flutter pub get
flutter run
🔒 Important Files to Exclude from Git
Make sure these files are in .gitignore:

gitignore

android/app/google-services.json
ios/Runner/GoogleService-Info.plist
lib/firebase_options.dart
✅ What You Need to Add Yourself
Your Firebase project config

.arb files (English, Marathi, Kannada)


📸 Screenshots

![IMG-20250501-WA0060](https://github.com/user-attachments/assets/afda99fb-0e73-4540-adf6-8ee9583def37)
![IMG-20250501-WA0056](https://github.com/user-attachments/assets/1331f975-23b7-4df4-b999-e31052f95695)
![IMG-20250501-WA0055](https://github.com/user-attachments/assets/4e2e18c4-ac91-40c1-8f3b-4f5a8f886131)
![IMG-20250501-WA0054](https://github.com/user-attachments/assets/f5a892e4-0e7a-47a3-9f7e-e7f0d80f9238)


👨‍💻 Developer
Rohit Nikam
I built this project to demonstrate how government services can be digitized for rural India in an accessible and modern way.

🌟 Thank You!
Thank you for visiting this project 🙏
If you found it helpful or inspiring, please give it a ⭐ on GitHub — it encourages me to build more open and impactful apps for the community.

Happy Coding! 💻✨
— Rohit Nikam

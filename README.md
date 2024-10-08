# HealthCare iOS App

**HealthCare** is a modern iOS application designed to provide users with access to digital health reports, AI-driven analysis, doctor consultations, and more. The app is built using SwiftUI and integrates Firebase for authentication and real-time data management.

## Features

- **User and Doctor Registration**: Separate registration flows for users and doctors with specialized data capture for doctors (e.g., specialty, address).
- **Appointment Booking**: Users can book appointments with doctors by selecting consultation dates and times.
- **AI Health Reports**: Personalized insights based on user health data, powered by AI analysis.
- **Doctor Profiles**: Detailed doctor profiles with specialties, consultation fees, and contact details.
- **Notifications**: Push notifications for appointment reminders and health alerts.
  
## Project structure

```
.
├── Healthcare
│   ├── AppointmentService.swift
│   ├── Assets.xcassets
│   ├── BookAppointment.swift
│   ├── Details.swift
│   ├── DocHomeView.swift
│   ├── FindDoctor.swift
│   ├── Firebase.swift
│   ├── GenrativeAI.swift
│   ├── HealthArticlesView.swift
│   ├── HealthcareApp.swift
│   ├── Home.swift
│   ├── Info.plist
│   ├── LabTestActivity.swift
│   ├── LoginView.swift
│   ├── MainView.swift
│   ├── Maps.swift
│   ├── Medicine.swift
│   ├── Preview Content
│   ├── Register.swift
│   ├── SwiftUIView.swift
│   ├── Zoom.swift
│   └── apiKey.swift
├── Healthcare.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   └── xcuserdata
├── HealthcareTests
│   └── HealthcareTests.swift
├── HealthcareUITests
│   ├── HealthcareUITests.swift
│   └── HealthcareUITestsLaunchTests.swift
└── README.md
```



## Technology Stack

- **iOS Development**: Swift, SwiftUI
- **Backend**: Firebase (Firestore, Authentication)
- **State Management**: SwiftUI's State and Environment Variables
- **UI Framework**: SwiftUI with custom views, components, and layouts


## Screenshots

|! <img src="https://github.com/Himanshu-00/HealthCare/blob/main/Healthcare/images/Home.png" alt="Home Screen" width="300"/> 
|!<img src="https://github.com/Himanshu-00/Healthcare/blob/main/Healthcare/images/upcoming.png" alt="Upcoming Appointments Screen" width="300"/>

<img src="https://github.com/Himanshu-00/Healthcare/blob/main/Healthcare/images/profile.png" alt="Profile Screen" width="300"/>



## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/HealthCare.git
    ```

2. Open the project in Xcode:

    ```bash
    cd HealthCare
    open HealthCare.xcodeproj
    ```

3. Install the required CocoaPods:

    ```bash
    pod install
    ```

4. Add your own Firebase configuration:

    - Download `GoogleService-Info.plist` from the Firebase Console.
    - Add the `GoogleService-Info.plist` to the Xcode project (ensure it's part of the app target).

5. Build and run the project on a simulator or a device.

## Firebase Setup

- **Authentication**: Email/password authentication for users and doctors.
- **Firestore**: Used to store user, doctor, and appointment data.
- **Firestore Structure**:
    - **Users Collection**: Stores user profile details.
    - **Doctors Collection**: Stores doctor information (e.g., specialty, address).
    - **Appointments Collection**: Stores user appointments with details like date, doctor, and fees.

## Contribution

If you wish to contribute:

1. Fork the repository.
2. Create a new feature branch (`feature/new-feature`).
3. Commit your changes.
4. Open a pull request.

## License

This project is licensed under the MIT License.

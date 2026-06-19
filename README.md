# Task Manager App (MVVM)

Task Manager App is a full-stack Flutter-based productivity application focused on scalable architecture, secure authentication, backend integration, and efficient state management. Built using REST APIs and Provider, this project demonstrates production-level Flutter development, API communication, authentication workflows, and clean app architecture following modern development standards.

## 🚀 Key Features

*   **User Authentication** – Implemented secure sign up, login, logout, and token-based authentication flow.
*   **Persistent Login** – Used Shared Preferences to securely store authentication tokens and maintain user sessions.
*   **OTP Password Recovery** – Integrated OTP verification and password reset functionality for secure account recovery.
*   **Task Management System** – Users can create, update, delete, and manage tasks with title, description, and status tracking (New, In Progress, Completed, Cancelled).
*   **Backend Integration** – Connected all task operations and user actions with REST APIs for real-time synchronization.
*   **Profile & Avatar Upload** – Users can update profile information and upload profile pictures.
*   **Central API Calling Service** – Designed a reusable centralized API service to improve code maintainability and scalability.
*   **Modern Architecture** – Followed MVVM (Model-View-ViewModel) architecture with proper separation of concerns.
*   **State Management** – Used Provider for reactive and efficient application-wide state management.

## 📸 Screenshot
<img width="1200" height="627" alt="to_do_linkedin" src="https://github.com/user-attachments/assets/3dbb6f7f-1f62-4080-9696-019bd35064b7" />

## 🛠️ Tech Stack

*   **Frontend:** Flutter (Dart)
*   **State Management:** Provider
*   **Architecture:** MVVM (Model-View-ViewModel)
*   **Backend Integration:** REST APIs (http package)
*   **Local Storage:** Shared Preferences
*   **Authentication:** Token-based (JWT) & OTP Verification
*   **Other Tools:** Image Upload, Form Validation, API Error Handling, Logger

## 🏗️ Project Structure

The project follows a clean directory structure to maintain separation of concerns:

- `lib/data/` - Models, API services (`ApiCaller`), and data sources.
- `lib/providers/` - State management logic using Provider.
- `lib/ui/` - Screens, widgets, and UI controllers.
- `lib/app.dart` - Main application configuration and routing.

## ⚙️ Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/of9_task_manager.git
    ```
2.  **Navigate to the folder:**
    ```bash
    cd of9_task_manager
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the application:**
    ```bash
    flutter run
    ```

---
*This project was developed to strengthen understanding of scalable Flutter architecture and real-world API-driven application development.*

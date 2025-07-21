# Personal Expense Tracker

## Overview

The **Personal Expense Tracker** is a fully functional mobile application that allows users to log daily expenses, categorize them, and view a summary of their spending habits. Built with **Flutter** for a seamless user experience, **gRPC** for efficient client-server communication, and a **database** for reliable storage, this app ensures smooth expense tracking and financial awareness.

## Features

### Frontend (Flutter)

- **Home Screen**: Displays total expenses for the current month and a list of daily expenses.
- **Add Expense Screen**: Enables users to input:
  - Title (e.g., "Lunch")
  - Amount
  - Category (Dropdown: Food, Travel, Shopping, etc.)
  - Date
- **Summary Screen**: Provides a bar chart or pie chart visualization of expenses categorized by type.

### Backend (gRPC Server)

- Built using **Python (gRPC + Protobuf)**.
- Implements the following gRPC services:
  - **ListExpenses**: Retrieves a list of expenses for a given date.
  - **AddExpense**: Adds a new expense to the database.
  - **DeleteExpense**: Removes an expense by ID.
  - **GetSummary**: Returns a summary of expenses grouped by category.

### Database

- Uses **SQLite** or **PostgreSQL**.
- Schema:
  ```sql
  CREATE TABLE expenses (
      id UUID PRIMARY KEY,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      category TEXT NOT NULL,
      date TIMESTAMP NOT NULL
  );
  ```
- Efficient CRUD operations enable seamless data management.

## Getting Started

### Prerequisites

- Install **Flutter**: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Install **protoc** (Protocol Buffers compiler) and ensure it’s on your `PATH`
- Install Python dependencies:
  ```sh
  pip install grpcio grpcio-tools SQLAlchemy psycopg2
  ```

### Installation

1. **Clone the Repository**

   ```sh
   git clone https://github.com/your-username/personal-expense-tracker.git
   cd personal-expense-tracker
   ```

2. **Generate gRPC Code & Run Backend**\
   Link to the automation script in your repo: [setup.py](./setup.py)

   From the project root run:

   ```bash
   python setup.py
   python server.py
   ```

3. **Launch the Flutter App**

   ```sh
   cd PersonalExpenseTracker
   flutter pub get
   flutter run
   ```

## Setup Script

The `setup.py` script automates the generation of gRPC code for both Python and Dart front-end. You can view and modify it directly: [setup.py](./setup.py)
In the setup.py just make sure you change the  r'C:\Users\ariqs\local\protoc-29.1-win64\include' to whereever your protoc application is

## Folder Structure

```
├─ .vscode/                 # VS Code settings
├─ android/                 # Android build files
├─ docs/                    # Documentation
├─ grpc-proto/              # .proto definitions
├─ ios/                     # iOS build files
├─ lib/                     # Dart source
│  ├─ backend/              # Python backend code
│  │  └─ python/            # Generated Python gRPC stubs & server code
│  ├─ pages/                # Flutter UI pages
│  ├─ services/             # Generated Dart gRPC client code
│  ├─ widgets/              # Reusable Flutter widgets
│  └─ main.dart             # App entrypoint
├─ linux/                   # Linux build files
├─ macos/                   # macOS build files
├─ test/                    # Unit & integration tests
├─ web/                     # Web build files
└─ windows/                 # Windows build files
```

## Future Enhancements

- **User Authentication**: Allow users to track expenses individually.
- **Analytics & Insights**: Provide insights like highest spending category or spending trends.

## License

The **Personal Expense Tracker** is licensed under the **MIT License**. Feel free to use, modify, and contribute.

---

### Contributors

- **Ariq Serazi** – Development & Maintenance

*For contributions, please fork the repository and submit a pull request! 🚀*


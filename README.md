# Personal Expense Tracker

## Overview

The **Personal Expense Tracker** is a simple mobile application that allows users to log daily expenses, categorize them, and view a summary of their spending habits. It is built using **Flutter** for the frontend, **gRPC** for client-server communication, and a **database** for persistent storage.

## Features

### Frontend (Flutter)

- **Home Screen**: Displays total expenses for the current month and a list of daily expenses.
- **Add Expense Screen**: Allows users to input:
  - Title (e.g., "Lunch")
  - Amount
  - Category (Dropdown: Food, Travel, Shopping, etc.)
  - Date
- **Summary Screen**: Provides a bar chart or pie chart visualization of expenses categorized by type.

### Backend (gRPC Server)

- Developed using **Python (gRPC + Protobuf)** or **Go**.
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
      date DATE NOT NULL
  );
  ```
- CRUD operations for storing, retrieving, updating, and deleting expenses.

## Development Steps

### 1. Frontend (Flutter)

- Design UI with Flutter widgets (ListView, DropdownButton, TextFormField).
- Use `grpc` package in Flutter to interact with the backend.

### 2. Backend (gRPC Server)

- Define the gRPC API using **Protocol Buffers (Protobuf)**.
- Implement gRPC services in **Python** or **Go**.
- Connect to the database using **SQLAlchemy (Python)** or raw SQL queries (Go).

### 3. Database Setup

- Create and migrate the database schema.
- Implement functions for CRUD operations.

### 4. Connect Flutter & Backend

- Generate **Dart gRPC stubs** from Protobuf definitions.
- Call backend services from the Flutter app.

### 5. Testing

- Use **BloomRPC** or CLI tools to test gRPC endpoints.
- Ensure Flutter app correctly communicates with the backend.

## Installation & Usage

### Prerequisites

- Install **Flutter** (https://flutter.dev/docs/get-started/install)
- Install **gRPC tools** for backend development
- Install **SQLite** or **PostgreSQL** for the database

### Steps to Run

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/your-username/personal-expense-tracker.git
   cd personal-expense-tracker
   ```
2. **Setup Backend**:
   - Install dependencies
     ```sh
     pip install grpcio grpcio-tools SQLAlchemy psycopg2
     ```
   - Run the gRPC server
     ```sh
     python server.py
     ```
3. **Setup Flutter App**:
   - Navigate to the frontend directory
     ```sh
     cd frontend
     ```
   - Install dependencies
     ```sh
     flutter pub get
     ```
   - Run the app on an emulator or device
     ```sh
     flutter run
     ```

## Future Enhancements

- **User Authentication**: Allow users to track expenses individually.
- **Export Data**: Enable exporting expense data to CSV or PDF.
- **Analytics & Insights**: Provide insights like highest spending category or spending trends.

## License

This project is licensed under the **MIT License**. Feel free to modify and distribute it as needed.

---

### Contributors

- **Your Name** - Initial development

If you'd like to contribute, please fork the repository and submit a pull request!

---

Enjoy tracking your expenses efficiently! 🚀

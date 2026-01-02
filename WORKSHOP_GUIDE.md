# MITA Workshop Guide

## Mini Issue Tracker Application

Welcome to the MITA workshop! In this hands-on session, you'll build a complete issue tracking application using your preferred backend technology while sharing a common React frontend.

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Setup Instructions](#setup-instructions)
5. [Workshop Tasks](#workshop-tasks)
6. [API Reference](#api-reference)
7. [Testing Your Implementation](#testing-your-implementation)
8. [Troubleshooting](#troubleshooting)

---

## Overview

### What You'll Build

A fully functional issue tracker where users can:
- Register and login with secure authentication
- Create, view, update, and delete their own issues
- Filter issues by status and priority
- Track issue workflow (Open → In Progress → Done)

### Technology Options

Choose **ONE** backend to implement:

| Backend | Language | Framework | Port |
|---------|----------|-----------|------|
| Java | Java 17+ | Spring Boot 4.0.1 | 8080 |
| .NET | C# | ASP.NET Core 10 | 5000 |
| PHP | PHP 8.2+ | Laravel 12 | 8000 |

All backends share:
- The same API contract (OpenAPI specification)
- The same React frontend
- The same MySQL database schema

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Frontend (React + TypeScript)              │
│                  http://localhost:5173                  │
│                                                         │
│   URL Routing:                                          │
│   /java/*   → Java backend                              │
│   /dotnet/* → .NET backend                              │
│   /php/*    → PHP backend                               │
└─────────────────────┬───────────────────────────────────┘
                      │ REST API
                      ▼
┌─────────────────────────────────────────────────────────┐
│                  Your Backend Choice                     │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │    Java     │  │    .NET     │  │     PHP     │     │
│  │ Spring Boot │  │ ASP.NET Core│  │   Laravel   │     │
│  │   :8080     │  │   :5000     │  │   :8000     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                    MySQL Database                        │
│                     localhost:3306                       │
└─────────────────────────────────────────────────────────┘
```

---

## Prerequisites

### All Participants

- [ ] Git installed
- [ ] MySQL 8.0 installed and running
- [ ] Node.js 18+ (for frontend)
- [ ] Code editor (VS Code recommended)

### Java Track

- [ ] Java 17 or higher (JDK)
- [ ] Maven 3.8+

### .NET Track

- [ ] .NET 10 SDK

### PHP Track

- [ ] PHP 8.2+
- [ ] Composer

---

## Setup Instructions

### Step 1: Create the Database

Connect to MySQL and create the database:

```sql
CREATE DATABASE mita;
CREATE USER 'mita'@'localhost' IDENTIFIED BY 'mita_password';
GRANT ALL PRIVILEGES ON mita.* TO 'mita'@'localhost';
FLUSH PRIVILEGES;
```

### Step 2: Clone the Frontend

```bash
git clone https://github.com/vmatviichuk-epam/mita-frontend.git
cd mita-frontend
npm install
```

### Step 3: Clone Your Chosen Backend

#### Option A: Java (Spring Boot)

```bash
git clone https://github.com/vmatviichuk-epam/mita-backend-java.git
cd mita-backend-java
```

#### Option B: .NET (ASP.NET Core)

```bash
git clone https://github.com/vmatviichuk-epam/mita-backend-dotnet.git
cd mita-backend-dotnet
```

#### Option C: PHP (Laravel)

```bash
# Create fresh Laravel project (recommended)
composer create-project laravel/laravel mita-backend-php
cd mita-backend-php

# Copy skeleton files
git clone https://github.com/vmatviichuk-epam/mita-backend-php.git temp-skeleton
cp temp-skeleton/app/Http/Controllers/AuthController.php app/Http/Controllers/
cp temp-skeleton/routes/api.php routes/
cp temp-skeleton/config/cors.php config/
rm -rf temp-skeleton

# Generate app key
php artisan key:generate
```

### Step 4: Verify the Setup

#### Start the Frontend

```bash
cd mita-frontend
npm run dev
```

Frontend will be available at: http://localhost:5173

#### Start Your Backend

**Java:**
```bash
cd mita-backend-java
./mvnw spring-boot:run
```

**.NET:**
```bash
cd mita-backend-dotnet
dotnet run
```

**PHP:**
```bash
cd mita-backend-php
php artisan serve --port=8000
```

#### Test the Connection

1. Open http://localhost:5173/java/login (or `/dotnet/` or `/php/`)
2. Enter any username and password
3. Click Login
4. You should see a success message with a mock JWT token

---

## Workshop Tasks

Complete these tasks in order. Each task builds on the previous one.

### Task 1: Database Setup (15 min)

Configure your backend to connect to MySQL and create the database schema.

#### Required Tables

```sql
-- Users table
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Issues table
CREATE TABLE issues (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status ENUM('Open', 'In Progress', 'Done') DEFAULT 'Open',
    priority ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

#### Java Hints
- Uncomment MySQL dependencies in `pom.xml`
- Configure `application.yml` with database connection
- Create `User` and `Issue` JPA entities

#### .NET Hints
- Add `Pomelo.EntityFrameworkCore.MySql` package
- Create `ApplicationDbContext` with `DbSet<User>` and `DbSet<Issue>`
- Configure connection in `appsettings.json`

#### PHP Hints
- Configure `.env` with database credentials
- Run `php artisan make:model User -m`
- Run `php artisan make:model Issue -m`
- Edit migrations and run `php artisan migrate`

---

### Task 2: User Registration (20 min)

Implement the registration endpoint.

#### Endpoint: `POST /api/auth/register`

**Request:**
```json
{
  "username": "johndoe",
  "password": "securePassword123"
}
```

**Response (201 Created):**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "username": "johndoe"
  }
}
```

**Error Response (409 Conflict):**
```json
{
  "error": {
    "code": "USERNAME_EXISTS",
    "message": "Username already taken"
  }
}
```

#### Requirements
- [ ] Username must be unique
- [ ] Password must be hashed (use bcrypt)
- [ ] Validate username is not empty
- [ ] Validate password is at least 8 characters

---

### Task 3: Real Authentication (25 min)

Replace the mock login with real authentication.

#### Endpoint: `POST /api/auth/login`

**Request:**
```json
{
  "username": "johndoe",
  "password": "securePassword123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "username": "johndoe"
  }
}
```

#### Requirements
- [ ] Verify username exists in database
- [ ] Verify password matches hash
- [ ] Generate real JWT token with user ID
- [ ] Return 401 for invalid credentials

#### JWT Payload Structure
```json
{
  "sub": "1",
  "username": "johndoe",
  "iat": 1699999999,
  "exp": 1700086399
}
```

#### JWT Libraries

| Backend | Library |
|---------|---------|
| Java | `io.jsonwebtoken:jjwt` |
| .NET | `System.IdentityModel.Tokens.Jwt` |
| PHP | `firebase/php-jwt` or Laravel Sanctum |

---

### Task 4: Issue CRUD Operations (30 min)

Implement all issue endpoints.

#### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/issues` | List user's issues |
| POST | `/api/issues` | Create new issue |
| GET | `/api/issues/{id}` | Get issue by ID |
| PUT | `/api/issues/{id}` | Update issue |
| DELETE | `/api/issues/{id}` | Delete issue |

#### Create Issue: `POST /api/issues`

**Request:**
```json
{
  "title": "Fix login bug",
  "description": "Users cannot login with special characters in password",
  "priority": "High"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "title": "Fix login bug",
  "description": "Users cannot login with special characters in password",
  "status": "Open",
  "priority": "High",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

#### Requirements
- [ ] All endpoints require authentication (JWT in Authorization header)
- [ ] Users can only access their OWN issues
- [ ] Default status is "Open"
- [ ] Default priority is "Medium"
- [ ] Title cannot be empty
- [ ] Return 404 if issue not found or belongs to another user

---

### Task 5: Issue Filtering (15 min)

Add filtering to the list issues endpoint.

#### Endpoint: `GET /api/issues?status=Open&priority=High`

**Query Parameters:**
- `status` (optional): Filter by status (Open, In Progress, Done)
- `priority` (optional): Filter by priority (Low, Medium, High)

**Example Responses:**

`GET /api/issues` - Returns all user's issues

`GET /api/issues?status=Open` - Returns only open issues

`GET /api/issues?priority=High&status=Open` - Returns high priority open issues

#### Requirements
- [ ] Support filtering by status
- [ ] Support filtering by priority
- [ ] Support combining multiple filters (AND logic)
- [ ] Default ordering by created_at ascending

---

### Task 6: Status Workflow (15 min)

Enforce valid status transitions when updating issues.

#### Valid Transitions

```
    ┌──────────────────────┐
    │                      │
    ▼                      │
┌────────┐    ┌───────────────┐    ┌────────┐
│  Open  │───▶│  In Progress  │───▶│  Done  │
└────────┘    └───────────────┘    └────────┘
    ▲                                   │
    └───────────────────────────────────┘
```

- Open → In Progress ✓
- In Progress → Done ✓
- Done → Open ✓ (reopen)
- Open → Done ✗ (invalid)
- Done → In Progress ✗ (invalid)

#### Requirements
- [ ] Validate status transitions on update
- [ ] Return 400 Bad Request for invalid transitions:

```json
{
  "error": {
    "code": "INVALID_STATUS_TRANSITION",
    "message": "Cannot transition from 'Open' to 'Done'"
  }
}
```

---

### Bonus Task: Activity Tracking (Optional)

Track all status and priority changes.

#### Activity Log Table

```sql
CREATE TABLE activity_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    issue_id BIGINT NOT NULL,
    change_type ENUM('status', 'priority') NOT NULL,
    old_value VARCHAR(50),
    new_value VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES issues(id) ON DELETE CASCADE
);
```

#### Requirements
- [ ] Log every status change
- [ ] Log every priority change
- [ ] Include activity in issue details response

---

## API Reference

### Authentication Header

All protected endpoints require:
```
Authorization: Bearer <jwt_token>
```

### Common Error Responses

| Status | Code | Description |
|--------|------|-------------|
| 400 | VALIDATION_ERROR | Invalid request data |
| 401 | UNAUTHORIZED | Missing or invalid token |
| 403 | FORBIDDEN | Not allowed to access resource |
| 404 | NOT_FOUND | Resource not found |
| 409 | CONFLICT | Resource already exists |

### Full API Specification

See the [OpenAPI specification](./openapi.yaml) for complete API documentation.

---

## Testing Your Implementation

### Using cURL

**Register:**
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}'
```

**Login:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}'
```

**Create Issue (with token):**
```bash
curl -X POST http://localhost:8080/api/issues \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"title": "My first issue", "description": "Test issue", "priority": "High"}'
```

**List Issues:**
```bash
curl http://localhost:8080/api/issues \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Using the Frontend

1. Navigate to your backend URL:
   - Java: http://localhost:5173/java/login
   - .NET: http://localhost:5173/dotnet/login
   - PHP: http://localhost:5173/php/login

2. Register a new account
3. Login with your credentials
4. Create and manage issues

---

## Troubleshooting

### CORS Errors

If you see CORS errors in the browser console:
- Ensure your backend allows `http://localhost:5173`
- Check that credentials are allowed
- Verify OPTIONS preflight requests are handled

### Database Connection

If you can't connect to MySQL:
```bash
# Check MySQL is running
mysql -u root -p -e "SHOW DATABASES;"

# Verify user permissions
mysql -u mita -p mita -e "SELECT 1;"
```

### JWT Issues

Common JWT problems:
- Token expired: Check `exp` claim
- Invalid signature: Ensure same secret key is used
- Malformed token: Check for extra whitespace

### Port Conflicts

If a port is in use:
```bash
# Find process using port
lsof -i :8080

# Kill process
kill -9 <PID>
```

---

## Resources

- [OpenAPI Specification](./openapi.yaml)
- [Frontend Repository](https://github.com/vmatviichuk-epam/mita-frontend)
- [Java Backend Repository](https://github.com/vmatviichuk-epam/mita-backend-java)
- [.NET Backend Repository](https://github.com/vmatviichuk-epam/mita-backend-dotnet)
- [PHP Backend Repository](https://github.com/vmatviichuk-epam/mita-backend-php)

---

## Need Help?

1. Check the troubleshooting section above
2. Review the API specification
3. Ask your workshop instructor

Good luck and happy coding!

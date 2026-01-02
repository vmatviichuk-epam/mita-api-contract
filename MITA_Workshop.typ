#set page(paper: "a4", margin: 2cm)
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: "1.")

// Title Page
#align(center)[
  #v(3cm)
  #text(size: 32pt, weight: "bold")[MITA]
  
  #v(0.3cm)
  
  #text(size: 18pt)[Mini Issue Tracker Application]
  
  #v(1cm)
  
  #line(length: 50%, stroke: 0.5pt + gray)
  
  #v(0.5cm)
  
  #text(size: 14pt, fill: gray)[Implementation Workshop]
  
  #v(4cm)
  
  #box(stroke: 1pt + luma(200), inset: 1.2em, radius: 4pt)[
    #text(size: 11pt)[
      *Choose ONE backend:* Java | .NET | PHP
    ]
  ]
]

#pagebreak()

// Workshop Overview
= Workshop Overview

In this workshop, you will build *MITA* — a Mini Issue Tracker Application.

The project consists of *multiple repositories*:
- One shared *React frontend*
- Three *backend implementations* (Java, .NET, PHP)
- One shared *API contract* (OpenAPI specification)

*Your task:* Choose *ONE* backend repository and implement all features according to the requirements. The frontend and API contract are already provided — you only implement the backend.

All three backends must produce identical API behavior. The frontend switches between backends via URL routes (`/java/*`, `/dotnet/*`, `/php/*`).

#v(1cm)

= Architecture

#align(center)[
#raw(block: true, lang: none, "
┌─────────────────────────────────────────────────────────────┐
│                      React Frontend                         │
│                    localhost:5173                           │
│                                                             │
│          /java/*    |    /dotnet/*    |    /php/*          │
└────────────────────────────┬────────────────────────────────┘
                             │
                             │  REST API (OpenAPI spec)
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
           ▼                 ▼                 ▼
   ┌───────────────┐ ┌───────────────┐ ┌───────────────┐
   │  Spring Boot  │ │  ASP.NET Core │ │    Laravel    │
   │    4.0.1      │ │      10       │ │      12       │
   │    :8080      │ │    :5000      │ │    :8000      │
   └───────┬───────┘ └───────┬───────┘ └───────┬───────┘
           │                 │                 │
           └─────────────────┼─────────────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │     MySQL 8.0       │
                  │   localhost:3306    │
                  └─────────────────────┘
")
]

#pagebreak()

// Requirements
= Requirements

== Goal

Provide a minimal issue-tracking application where authenticated users manage their own issues. The application must support user registration, login, issue CRUD operations, controlled status transitions, priority changes, filtering, and optional activity tracking. All data must be stored in a MySQL database.

== Description

Implement a strictly scoped issue tracker that enables each authenticated user to create, update, view, and delete their own issues. The system must enforce user isolation, require authentication for all issue operations, and follow predefined workflows for status and priority changes.

#v(0.5cm)

== 1. User Authentication & Management

- Users must be able to register with a unique username and a password.
- Users must be able to log in using their registered credentials.
- After login, users must obtain a session or token that is required for all subsequent operations.
- Users must be able to log out, invalidating their session or token.
- Users must only be able to access their own issues. Access to issues owned by other users must be denied.

== 2. Issue Creation & Management

- Users must be able to create issues with the following required fields: title, description, status, priority, creation timestamp.
- The default value for status must be *Open*.
- The default value for priority must be *Medium*.
- Users must be able to update all issue fields except the creation timestamp.
- Users must be able to delete issues they own.
- Title and description must not be empty.

== 3. Issue Workflow

Allowed status values: *Open*, *In Progress*, *Done*

Allowed priority values: *Low*, *Medium*, *High*

Allowed status transitions:
- Open → In Progress
- In Progress → Done
- Done → Open

#align(center)[
#raw(block: true, lang: none, "
       ┌────────────────────────────────────────┐
       │                                        │
       ▼                                        │
  ┌─────────┐       ┌─────────────┐       ┌─────────┐
  │  Open   │ ────▶ │ In Progress │ ────▶ │  Done   │
  └─────────┘       └─────────────┘       └─────────┘
       ▲                                        │
       └────────────────────────────────────────┘
")
]

Users must not set the status to a value outside the allowed list.

Users must not set the priority to a value outside the allowed list.

#pagebreak()

== 4. Issue Listing & Filtering

- Users must be able to retrieve a list of their own issues.
- Users must be able to filter issues by status.
- Users must be able to filter issues by priority.
- If multiple filters are provided, the system must apply all provided filters simultaneously.
- The default ordering must be by creation timestamp ascending.

== 5. Activity Tracking (Optional)

If activity tracking is implemented:
- Every status change must create an activity entry.
- Every priority change must create an activity entry.
- An activity entry must contain: issue reference, timestamp, change type, old value, new value.
- Activity entries must be immutable.
- Activity entries must be retrievable as part of the issue details.

== 6. Storage & Persistence

- The application must store all data in a *MySQL database*.
- The schema must include at minimum: `users`, `issues`, `activity_log` (if activity tracking is implemented).
- Passwords must be stored in hashed form.
- Foreign key constraints must enforce user-to-issue ownership.

== 7. UI (Already Provided)

The frontend is already implemented and contains:
- A login page
- A page listing user issues with filtering controls
- A page for creating and editing issues

All UI actions map directly to the defined backend operations.

#v(0.5cm)

== Success Criteria

- The application must implement exactly the features described above.
- All core operations must require authentication.
- User data and issue data must remain isolated at all times.

#pagebreak()

= Repositories

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: none,
  row-gutter: 1em,
  
  [*API Contract*], [#link("https://github.com/vmatviichuk-epam/mita-api-contract")],
  [*Frontend*], [#link("https://github.com/vmatviichuk-epam/mita-frontend")],
  [], [],
  [*Java Backend*], [#link("https://github.com/vmatviichuk-epam/mita-backend-java")],
  [*.NET Backend*], [#link("https://github.com/vmatviichuk-epam/mita-backend-dotnet")],
  [*PHP Backend*], [#link("https://github.com/vmatviichuk-epam/mita-backend-php")],
)

#v(1.5cm)

#box(stroke: 1pt + luma(180), inset: 1.2em, radius: 4pt, width: 100%)[
  *Getting Started*
  
  ```
  1. Clone the frontend repository
  2. Clone ONE backend repository of your choice
  3. Ensure MySQL is running on localhost:3306
  4. Start the frontend:  npm install && npm run dev
  5. Start your backend (see backend repo README)
  6. Open browser: http://localhost:5173/java/login
                   http://localhost:5173/dotnet/login
                   http://localhost:5173/php/login
  ```
]

#v(1cm)

#align(center)[
  #text(size: 10pt, fill: gray)[
    Full API specification available in `openapi.yaml`
  ]
]

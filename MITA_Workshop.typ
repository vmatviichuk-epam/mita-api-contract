#set page(paper: "a4", margin: 2cm)
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: "1.")

#align(center)[
  #text(size: 28pt, weight: "bold")[MITA Workshop]
  
  #v(0.5cm)
  
  #text(size: 16pt)[Mini Issue Tracker Application]
  
  #v(1cm)
  
  #text(size: 12pt, fill: gray)[Multi-Backend Implementation Workshop]
]

#v(2cm)

#align(center)[
  #box(stroke: 1pt + gray, inset: 1em, radius: 4pt)[
    #text(size: 10pt)[
      *Choose your backend:* Java (Spring Boot) | .NET (ASP.NET Core) | PHP (Laravel)
    ]
  ]
]

#pagebreak()

= Architecture

#align(center)[
#raw(block: true, lang: none, "
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                    React Frontend                           │
│                  localhost:5173                             │
│                                                             │
│   Routes:  /java/*  |  /dotnet/*  |  /php/*                │
│                                                             │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           │ REST API
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
         ▼                 ▼                 ▼
┌─────────────────┐ ┌─────────────┐ ┌─────────────────┐
│                 │ │             │ │                 │
│   Spring Boot   │ │  ASP.NET    │ │    Laravel      │
│   4.0.1         │ │  Core 10    │ │    12           │
│                 │ │             │ │                 │
│   :8080         │ │   :5000     │ │   :8000         │
│                 │ │             │ │                 │
└────────┬────────┘ └──────┬──────┘ └────────┬────────┘
         │                 │                 │
         └─────────────────┼─────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │                        │
              │      MySQL 8.0         │
              │      localhost:3306    │
              │                        │
              └────────────────────────┘
")
]

#v(1cm)

#table(
  columns: (1fr, 1fr, 1fr),
  align: center,
  table.header([*Java*], [*.NET*], [*PHP*]),
  [Spring Boot 4.0.1], [ASP.NET Core 10], [Laravel 12],
  [Port 8080], [Port 5000], [Port 8000],
  [Maven], [.NET CLI], [Composer],
)

#pagebreak()

= Requirements

== User Authentication & Management

- Users register with unique username and password
- Users login to obtain session/token for subsequent operations
- Users logout to invalidate session/token
- Users access only their own issues

== Issue Management

- Create issues with: *title*, *description*, *status*, *priority*, *creation timestamp*
- Default status: *Open*
- Default priority: *Medium*
- Update all fields except creation timestamp
- Delete owned issues
- Title and description must not be empty

== Issue Workflow

#align(center)[
#raw(block: true, lang: none, "
         ┌───────────────────────────────┐
         │                               │
         ▼                               │
    ┌─────────┐      ┌─────────────┐     │     ┌─────────┐
    │  Open   │ ───▶ │ In Progress │ ───▶│───▶ │  Done   │
    └─────────┘      └─────────────┘           └─────────┘
         ▲                                          │
         └──────────────────────────────────────────┘
")
]

#table(
  columns: (1fr, 1fr),
  align: center,
  table.header([*Status Values*], [*Priority Values*]),
  [Open, In Progress, Done], [Low, Medium, High],
)

#v(0.5cm)

*Valid Transitions:*
- Open → In Progress
- In Progress → Done  
- Done → Open (reopen)

== Filtering

- List own issues
- Filter by status
- Filter by priority
- Combine filters (AND logic)
- Order by creation timestamp ascending

== Storage

- MySQL database
- Tables: `users`, `issues`
- Passwords stored hashed
- Foreign key: user → issues

#pagebreak()

= Repositories

#v(1cm)

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: none,
  row-gutter: 0.8em,
  
  [*API Contract*], [#link("https://github.com/vmatviichuk-epam/mita-api-contract")],
  [*Frontend*], [#link("https://github.com/vmatviichuk-epam/mita-frontend")],
  [*Java Backend*], [#link("https://github.com/vmatviichuk-epam/mita-backend-java")],
  [*.NET Backend*], [#link("https://github.com/vmatviichuk-epam/mita-backend-dotnet")],
  [*PHP Backend*], [#link("https://github.com/vmatviichuk-epam/mita-backend-php")],
)

#v(2cm)

#align(center)[
  #box(stroke: 1pt + gray, inset: 1.5em, radius: 4pt, width: 80%)[
    #align(left)[
      *Quick Start*
      
      ```bash
      # 1. Clone frontend
      git clone https://github.com/vmatviichuk-epam/mita-frontend
      
      # 2. Clone your chosen backend
      git clone https://github.com/vmatviichuk-epam/mita-backend-java
      
      # 3. Start MySQL on port 3306
      
      # 4. Run frontend: npm install && npm run dev
      
      # 5. Run backend (see repo README)
      
      # 6. Open http://localhost:5173/java/login
      ```
    ]
  ]
]

#v(1cm)

#align(center)[
  #text(size: 9pt, fill: gray)[
    See `openapi.yaml` in API Contract repo for full endpoint specification
  ]
]

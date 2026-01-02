# MITA API Contract

OpenAPI specification for the **Mini Issue Tracker Application (MITA)**.

This repository serves as the single source of truth for the API contract that all backend implementations must follow.

## Overview

MITA is a workshop project demonstrating how to build the same API with different backend technologies while sharing a common frontend.

## Backend Implementations

| Backend | Repository | Port |
|---------|------------|------|
| Java (Spring Boot 4.0.1) | [mita-backend-java](https://github.com/vmatviichuk-epam/mita-backend-java) | 8080 |
| .NET (ASP.NET Core 10) | [mita-backend-dotnet](https://github.com/vmatviichuk-epam/mita-backend-dotnet) | 5000 |
| PHP (Laravel 12) | [mita-backend-php](https://github.com/vmatviichuk-epam/mita-backend-php) | 8000 |

## Frontend

| Frontend | Repository | Port |
|----------|------------|------|
| React + TypeScript | [mita-frontend](https://github.com/vmatviichuk-epam/mita-frontend) | 5173 |

## Using as Submodule

Backend repositories include this contract as a git submodule:

```bash
# Clone with submodules
git clone --recurse-submodules <backend-repo-url>

# Or initialize after cloning
git submodule update --init --recursive
```

## API Endpoints

### Currently Implemented (Skeleton)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | User login (returns mock JWT) |

### To Be Implemented (Workshop)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | User registration |
| POST | `/api/auth/logout` | User logout |
| GET | `/api/issues` | List user's issues |
| POST | `/api/issues` | Create new issue |
| GET | `/api/issues/{id}` | Get issue details |
| PUT | `/api/issues/{id}` | Update issue |
| DELETE | `/api/issues/{id}` | Delete issue |

## Mock Response

All backend skeletons return the same mock response for `/api/auth/login`:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidXNlcm5hbWUiOiJ0ZXN0dXNlciJ9.MOCK",
  "user": {
    "id": 1,
    "username": "testuser"
  }
}
```

## Viewing the Spec

You can view and interact with this API specification using:

- [Swagger Editor](https://editor.swagger.io/) - paste the `openapi.yaml` content
- [Swagger UI](https://petstore.swagger.io/) - provide the raw GitHub URL

## License

MIT

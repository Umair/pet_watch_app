# Pet Watch API

A RESTful API built with Ruby on Rails 7 for managing pets with user authentication and background job processing.

## Features

- **User Authentication**: JWT-based token authentication
- **Pet Management**: CRUD operations for pets
- **Background Jobs**: Sidekiq for processing vaccination expiration notifications
- **Database**: PostgreSQL with proper associations
- **API Mode**: Rails API-only for lightweight responses

## Tech Stack

- Ruby on Rails 7.1
- PostgreSQL
- Sidekiq (Background Jobs)
- Redis
- JWT (Authentication)
- bcrypt (Password Hashing)

## Setup

### Prerequisites

- Ruby 3.3+
- PostgreSQL
- Redis

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:Umair/pet_watch_app.git
   cd pet_watch_app
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   bundle exec rails db:create
   bundle exec rails db:migrate
   bundle exec rails db:seed
   ```

4. **Start the services**
   ```bash
   # Terminal 1: Start Rails server
   bundle exec rails server
   
   # Terminal 2: Start Sidekiq (for background jobs)
   bundle exec sidekiq
   
   # Terminal 3: Start Redis (if not running)
   redis-server
   ```

## API Documentation

### Authentication (API)

#### Sign Up
```http
POST /api/v1/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password",
  "password_confirmation": "password"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

#### Sign In
```http
POST /api/v1/signin
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### Pets API (under `/api/v1` namespace)

All pet endpoints require authentication. Include the JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

#### Create Pet
```http
POST /api/v1/pets
Authorization: Bearer <token>
Content-Type: application/json

{
  "pet": {
    "name": "Charlie",
    "breed": "Beagle",
    "age": 4
  }
}
```

#### List All Pets (User's pets only)
```http
GET /api/v1/pets
Authorization: Bearer <token>
```

#### Get Pet Details
```http
GET /api/v1/pets/:id
Authorization: Bearer <token>
```

#### Mark Vaccination as Expired
```http
PATCH /api/v1/pets/:id/mark_expired
Authorization: Bearer <token>
```

**Note:** This triggers a background job that simulates sending an email notification.

## Testing with CURL

### 1. Sign Up
```bash
curl -X POST http://localhost:3000/api/v1/signup \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password", "password_confirmation": "password"}'
```

### 2. Sign In
```bash
curl -X POST http://localhost:3000/api/v1/signin \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password"}'
```

### 3. Create Pet (use token from signin)
```bash
curl -X POST http://localhost:3000/api/v1/pets \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{"pet": {"name": "Buddy", "breed": "Golden Retriever", "age": 3}}'
```

### 4. List Pets
```bash
curl -H "Authorization: Bearer YOUR_TOKEN_HERE" http://localhost:3000/api/v1/pets
```

### 5. Mark Vaccination Expired
```bash
curl -X PATCH http://localhost:3000/api/v1/pets/1/mark_expired \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Postman Collection

Import the `Pet_Watch_API.postman_collection.json` file into Postman for easy testing. All API endpoints are now under the `/api/v1` namespace.

## Background Jobs

When a pet's vaccination is marked as expired, a background job (`NotifyVaccinationExpiredJob`) is triggered that:

1. Logs a simulated email notification
2. Can be extended to send actual emails

To see the job output, check the Sidekiq logs or Rails server logs.

## Database Schema

### Users
- `id` (Primary Key)
- `email` (String, unique)
- `password_digest` (String)
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

### Pets
- `id` (Primary Key)
- `name` (String)
- `breed` (String)
- `age` (Integer)
- `vaccination_expired` (Boolean, default: false)
- `user_id` (Foreign Key to Users)
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

## Development

### Running Tests
```bash
bundle exec rails test
```

### Sidekiq Web UI
Access Sidekiq monitoring at: `http://localhost:3000/sidekiq`

### Database Console
```bash
bundle exec rails console
```


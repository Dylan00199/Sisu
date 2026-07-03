# Backend Handoff Contract

This front-end currently uses mock repositories. Replace each repository with HTTP calls when Spring Boot is ready.

## Suggested Base URL

`http://localhost:8080/api`

## Suggested Endpoints

### Home

- `GET /home/streak`
- `GET /home/discover`
- `GET /posts/feed`
- `GET /posts/{postId}`

### Workout

- `GET /routines`
- `POST /routines`
- `GET /routines/{routineId}`
- `POST /routines/{routineId}/exercises`
- `GET /plans`

Validation:

- Do not allow saving an empty routine.
- Keep at least 3 default plans available.

### Profile

- `GET /profile/me`
- `GET /profile/me/calendar?month=YYYY-MM`
- `GET /profile/me/statistics`
- `GET /profile/me/friends`
- `GET /profile/{userId}`

### Notifications

- `GET /notifications`
- `PATCH /notifications/{notificationId}/read`

### AI Assistant

- `POST /ai/chat`

Body:

```json
{
  "message": "I want to train chest today",
  "userContext": {
    "goal": "muscle gain",
    "experience": "beginner",
    "availableDaysPerWeek": 4
  }
}
```

Response:

```json
{
  "answer": "Suggested workout..."
}
```

### GymRoom Finder

- `GET /gym-rooms?lat=10.77&lng=106.69&sort=nearest`
- `GET /gym-rooms/{gymRoomId}`

## Front-End Integration Point

Start replacing mock data in:

- `lib/features/home/repositories/home_repository.dart`
- `lib/features/workout/repositories/workout_repository.dart`
- `lib/features/profile/repositories/profile_repository.dart`
- `lib/features/notification/repositories/notification_repository.dart`
- `lib/features/ai_assistant/repositories/ai_repository.dart`
- `lib/features/gym_room/repositories/gym_room_repository.dart`

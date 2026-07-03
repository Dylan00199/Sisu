# Sisu Gym App

Flutter front-end for the Sisu gym tracker hackathon idea.

## Current Front-End Scope

- Home social feed, discover users, week/month streak.
- Home search, public profile view, and post detail with like/comment.
- Workout routines, routine builder validation, add exercise, and classic training plans.
- Profile calendar, statistics, measures, exercise records, my workouts, records, friends.
- Notifications for friends, reminders, and personal records.
- AI Gym Assistant mock chat.
- GymRoom Finder with active gym list, district filter, and gym detail screen.
- Dark/light theme toggle.
- Vietnamese/English localization.

The UI currently uses mock repositories so the front-end can be demoed without a backend. Replace repository implementations with Spring Boot API calls when the backend is ready.

## Run

If this folder does not yet contain `android/` and `ios/`, generate platform folders first:

```bash
flutter create . --platforms=android,ios
```

Then install dependencies and run:

```bash
flutter pub get
flutter run
```

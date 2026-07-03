# Frontend Implementation Checklist

## FR01 - Home

Implemented files:

- `lib/features/home/views/home_screen.dart`
- `lib/features/home/views/post_card_widget.dart`
- `lib/features/home/views/post_detail_screen.dart`
- `lib/features/home/views/public_profile_screen.dart`
- `lib/features/home/views/streak_banner_widget.dart`

Demo flow:

- Home shows week/month streak, discover, search, and feed.
- Tap search icon to open search sheet.
- Tap a discover profile to open another user's profile.
- Tap a feed post to open post detail, like it, and add a comment.

## FR02 - Workout

Implemented files:

- `lib/features/workout/views/workout_screen.dart`
- `lib/features/workout/views/routine_builder_screen.dart`
- `lib/features/workout/views/routine_detail_screen.dart`

Demo flow:

- Workout shows existing routines.
- Switch to Plans to view at least 3 classic workout plans.
- Tap New Routine, add a title and at least one exercise.
- Try saving without title/exercise to see validation.

## FR03 - Profile

Implemented files:

- `lib/features/profile/views/profile_screen.dart`
- `lib/features/profile/views/calendar_widget.dart`
- `lib/features/profile/views/body3d_viewer_widget.dart`

Demo flow:

- Profile shows current-month calendar.
- Tabs include Stats, Measures, Exercises, My workouts, Records, Friends.
- Stats includes body focus/body model placeholder.
- My workouts are listed newest first.

## FR03b - Notifications

Implemented files:

- `lib/features/notification/views/notification_screen.dart`

Demo flow:

- Notifications show friend posts, reminders, records, and weekly goal messages.
- Filter chips switch between notification categories.

## FR04 - AI Assistant

Implemented files:

- `lib/features/ai_assistant/views/ai_chat_screen.dart`

Demo flow:

- Open AI Coach from Home.
- Ask a gym technique or diet question.
- Mock repository returns a safe coaching answer.

## FR05 - GymRoom

Implemented files:

- `lib/features/gym_room/views/gym_map_screen.dart`
- `lib/features/gym_room/views/gym_filter_bottom_sheet.dart`
- `lib/features/gym_room/views/gym_room_detail_screen.dart`

Demo flow:

- Open Gym Rooms from Home.
- Use filter icon to filter by district or sort.
- Only active gyms are displayed.
- Tap a gym to view details.

## NFR

- NFR01 Responsive: Flutter layout uses scroll views, flexible rows, wrap chips, and Material widgets.
- NFR02 Dark/Light mode: implemented in `lib/core/theme` and toggle in Profile.
- NFR03 VI/EN language: implemented in `lib/core/l10n` and toggle in Profile.

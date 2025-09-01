# Eat the Alphabet (iOS) App
A gamified iOS app that helps adventurous food lovers complete the Eat the Alphabet Challenge: visiting 26 different restaurants, each starting with a different letter of the alphabet. The app tracks progress, stores dining experiences, and encourages culinary exploration through a fun and interactive experience.

## Overview
The Eat the Alphabet challenge encourages participants to try restaurants whose names begin with each letter of the alphabet. Unlike traditional restaurant picker apps, EtA focuses on exploration and variety by:
- Tracking your alphabet progress
- Recording experiences with reviews, photos, and ratings
- Providing statistics on your dining habits

## Features
- User Authentication via Supabase for secure account management
- Challenge Management: Create and join challenges to progress through the alphabet alone or with friends
- Restaurant Browsing: Find restaurants within a specified radius using Apple’s MapKit integration.
- Statistics Dashboard: View progress and insights.
- Tab-based Navigation: Intuitive layout for accessing Challenges, Friends, and Profile pages.

## Architecture
- Pattern: MVVM
- Key Components:
  - Models: Swift structs conforming to `Codable` and `Identifiable`
  - Views: Built with SwiftUI for declarative UI
  - ViewModels: Business logic and state management
  - Repositories: Handle data operations via Supabase

## Screenshots
| Account View   | Challenge View | Restaurant Select |
| -------- | ------- | ------- |
| ![alt text](https://github.com/kbeaverson/Eat-the-Alphabet/blob/main/Eat%20the%20Alphabet/screenshots/account_view.png) | ![alt text](https://github.com/kbeaverson/Eat-the-Alphabet/blob/main/Eat%20the%20Alphabet/screenshots/challenge_view.PNG) | ![alt text](https://github.com/kbeaverson/Eat-the-Alphabet/blob/main/Eat%20the%20Alphabet/screenshots/restaurant_select.PNG) |

## Database Schema
*Coming soon*

## Testing
- Unit Tests: verify repository operations
- UI Tests: validate core user flows such as authentication and navigation

## Future Improvements
- Friends Page: Social features to invite and join challenges with friends.
- Enhanced Restaurant Data: Integrate third-party API (like Foursquare Places API) for richer restaurant details
- Group Challenge Management: Random selection of restaurants for group events based on group preferences

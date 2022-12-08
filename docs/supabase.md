# Supabase (Database)
The mobile app and web application uses a Supabase database. Supabase is an open source Firebase alternative. Start your project with a Postgres database, Authentication, instant APIs, Edge Functions, Realtime subscriptions, and Storage.<br>

Supabase was chosen because of the following reasons:

 - Supports realtime features, important for show data during sessions in realtime
 - Has support for Flutter and Nextjs (frameworks used in this project)
 - Easy authentication integration
 - Automatad API documentation
 - Can be run both in the cloud and locally/self hosted

The last feature is esspecially important because one of the requirements of Team-NL is that they want to self host their infrastructure.<br>

The database will be ran in the cloud during the development phase, because this makes development faster and easeier.

## Schema
![Database Schema](images/Supbase%20Schema.png)

- **sessions** store active and previous sessions, for active sessions `ended_at` will be `NULL` untill the session finishes
- **scripts** store informatie about uploaded scripts that can be ran on the data of sessions
- **script_outputs** stores the of an enabled script for a given session

## Database API documentation
Supabase automatically create API documentation: [Supabase documentation](https://app.supabase.com/project/xwxwhsqpsnumkfazbegs/api)

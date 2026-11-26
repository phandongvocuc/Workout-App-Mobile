# HydroFit Gym & Fitness Center - Spring Boot Backend

## Prerequisites
1. **Java 17+** (installed on this machine)
2. **PostgreSQL** running on `localhost:5432`
3. **Maven** (or IntelliJ IDEA / VS Code Java Extension Pack)

## Database Setup
Create the PostgreSQL database before starting the server:
```sql
CREATE DATABASE hydrofit;
```
Update `src/main/resources/application.properties` if your PostgreSQL username/password differs from `postgres` / `postgres`.

## Running the Backend
From the `backend/` folder:
```bash
mvn spring-boot:run
```
The server starts on `http://0.0.0.0:8080`.

## Default Credentials
- **Admin (hardcoded):**
  - Email: `admin@hydrofit.com`
  - Password: `admin123`
- **Sample Member (auto-seeded if `app_users` table is empty):**
  - Email: `member@hydrofit.com`
  - Password: `123456`

## Connecting from Flutter
- **Android Emulator:** `http://10.0.2.2:8080` (default in the app)
- **Windows / Web (same machine):** `http://localhost:8080`
- **Physical Phone on same Wi-Fi:** `http://<YOUR_LAPTOP_LAN_IP>:8080` (configurable right on the Login screen)


# Getting Fast at Geblang

A minimal **API-only** [Geblang](https://geblang.davegebler.com) application in the *-101 family. It mirrors the JSON API contract of [laravel-101](https://github.com/iammikek/laravel-101) and [flask-101](https://github.com/iammikek/flask-101) with JWT auth, SQLite persistence, and built-in `geblang test` feature tests — but **no server-rendered shop UI**.

**Audience:** Laravel / PHP / Python developers exploring Geblang (typed scripting on a Go runtime) using the same items/categories API.

## What is Geblang?

[Geblang](https://github.com/dwgebler/geblang) is a general-purpose scripting language implemented in Go, created by [Dave Gebler](https://github.com/dwgebler). It aims for PHP/Python-style ergonomics with static typing, first-class async, modules, and a batteries-included standard library (HTTP, routing, databases, JWT, testing, and more).

- **Language & runtime:** [github.com/dwgebler/geblang](https://github.com/dwgebler/geblang)
- **Reference manual:** [geblang.davegebler.com](https://geblang.davegebler.com)

This *-101 repo is a learning API on top of that stack — not the language itself.

## API-only by design

Other *-101 projects (Laravel, Django, Rails, Orchestr) include a `/shop` browser UI. **geblang-101 deliberately omits that layer** and focuses on a lean JSON REST API with `web.router`, a thin service layer, and SQLite via `db.Connection`.

## What's included

1. **Geblang 1.32** REST API on port **8013**
2. **SQLite** via `db.Connection` (foreign keys on)
3. **JWT auth** — register, login (form-urlencoded `username`/`password`), Bearer on writes
4. **Services** — user, category, item modules under `src/services/`
5. **Domain errors** with `{ detail, code }` responses
6. **Pagination** — `{ items, total, skip, limit }` plus item filters
7. **Stats** — `GET /items/stats/summary`
8. **18 feature tests** via `geblang test` + `web.router` dispatch (no live HTTP server required)
9. Dockerfile (`dwgebler/geblang`), docker-compose, GitHub Actions CI, Makefile

## Quick Start

### Local (Geblang installed)

```bash
cd geblang-101
cp .env.example .env
make serve
```

Or with Docker only (no local `geblang` binary):

```bash
make serve-docker
```

Open **http://127.0.0.1:8013/** — hello message  
**http://127.0.0.1:8013/items** — JSON list

### Tests

```bash
make test
# or without a local install:
make test-docker
```

### Docker Compose

```bash
docker compose up --build
```

API on **http://localhost:8013**.

## Project Structure

```
geblang-101/
├── src/
│   ├── main.gb              # http.serve entrypoint
│   ├── app.gb               # router + CORS
│   ├── settings.gb          # env config (not named config — stdlib collision)
│   ├── domain.gb            # DomainError hierarchy (not named errors)
│   ├── database.gb          # SQLite connection + migrate
│   ├── security.gb          # passwordHash + JWT
│   ├── validators.gb        # Laravel-style messages
│   ├── serializers.gb
│   ├── routes/              # health, auth, categories, items
│   ├── services/            # user, category, item
│   └── support/             # HTTP helpers + testkit
├── database/schema.sql
├── tests/feature/           # 18 feature tests
├── Dockerfile
├── docker-compose.yml
└── Makefile
```

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `PORT` / `X_LISTEN` | `8013` | Listen port |
| `APP_HOST` | `127.0.0.1` | Bind address (`0.0.0.0` in Docker) |
| `DB_DATABASE` | `database/database.sqlite` | SQLite file path |
| `JWT_SECRET` | `change-me-in-production` | HS256 signing secret |
| `CORS_ORIGINS` | localhost SPA ports | Allowed browser origins |

## API Endpoints

| Path | Method | Auth | Purpose |
|------|--------|------|---------|
| `/` | GET | — | Hello message |
| `/health` | GET | — | Health check |
| `/auth/register` | POST | — | Create user |
| `/auth/login` | POST | — | Get JWT (form `username` + `password`) |
| `/auth/me` | GET | JWT | Current user |
| `/categories` | GET/POST | JWT on POST | List/create |
| `/categories/:id` | GET/PATCH/DELETE | JWT on writes | CRUD |
| `/items` | GET/POST | JWT on POST | List/create |
| `/items/stats/summary` | GET | — | Statistics |
| `/items/:id` | GET/PATCH/DELETE | JWT on writes | CRUD |

Query params on `GET /items`: `skip`, `limit`, `category_id`, `name_contains`, `min_price`, `max_price`.

## Laravel → Geblang Mapping

| Laravel | geblang-101 |
|---------|-------------|
| Sanctum / jwt-auth | `crypt.jwtSign` / `jwtVerify` + `Authorization: Bearer` |
| Controllers | `src/routes/*.gb` + `web.router` |
| Form Requests | `validators.gb` (Laravel-style messages) |
| Eloquent | `db.Connection` + service modules |
| `paginate()` | `{ items, total, skip, limit }` |
| `@auth` middleware | `security.requireAuth()` |
| PHPUnit | `geblang test` + classes extending `test.Test` |

## Geblang notes for this project

- Comments use `#`, not `//` (`//` is integer division).
- Local modules named `config` / `errors` collide with stdlib — this app uses `settings` and `domain`.
- `:memory:` SQLite uses a single pooled connection: close query cursors before the next query/exec, or list endpoints can deadlock.
- Feature tests dispatch through `router.handle` (see `support.testkit`) instead of binding a port.

## *-101 Family

### API backends

| Repo | Port | Type | Stack |
|------|------|------|-------|
| [fastAPI-101](https://github.com/iammikek/fastAPI-101) | 8000 | API-only | FastAPI, SQLAlchemy |
| [django-101](https://github.com/iammikek/django-101) | 8001 | Monolith | Django + DRF + shop |
| [symfony-101](https://github.com/iammikek/symfony-101) | 8002 | Monolith | Symfony + shop |
| [laravel-101](https://github.com/iammikek/laravel-101) | 8003 | Monolith | Laravel + shop |
| [framework-x-101](https://github.com/iammikek/framework-x-101) | 8004 | Monolith | Framework X + shop |
| [orchestr-101](https://github.com/iammikek/orchestr-101) | 8005 | Monolith | Orchestr + shop |
| [nest-101](https://github.com/iammikek/nest-101) | 8006 | API-only | NestJS, TypeScript |
| [express-101](https://github.com/iammikek/express-101) | 8007 | API-only | Express, Vitest |
| [go-101](https://github.com/iammikek/go-101) | 8000* | API-only | Gin, GORM |
| [fortran-101](https://github.com/iammikek/fortran-101) | 8008 | API-only | Fortran, fpm |
| [java-101](https://github.com/iammikek/java-101) | 8009 | API-only | Spring Boot, JPA, Flyway |
| [dotNet-101](https://github.com/iammikek/dotNet-101) | 8010 | API-only | ASP.NET Core, xUnit |
| [flask-101](https://github.com/iammikek/flask-101) | 8011 | API-only | Flask, pytest |
| [rails-101](https://github.com/iammikek/rails-101) | 8012 | Monolith | Rails + shop |
| [**geblang-101**](https://github.com/iammikek/geblang-101) | **8013** | API-only | Geblang, SQLite |
| [gebweb-101](https://github.com/iammikek/gebweb-101) | 8014 | API-only | Geblang + Gebweb |
\* go-101 also uses port 8000 — run one backend at a time, or change port in config.

### Other clients

| Repo | Platform | Stack |
|------|----------|-------|
| [flutter-101](https://github.com/iammikek/flutter-101) | Mobile / desktop | Flutter (iOS, macOS, Android) |
| [react-101](https://github.com/iammikek/react-101) | Web browser | React 19, Vite, Vitest |
| [vue-101](https://github.com/iammikek/vue-101) | Web browser | Vue 3, Vite, Pinia |
| [alpine-101](https://github.com/iammikek/alpine-101) | Web browser | Alpine.js, Vite, Vitest |

### Suggested pairing

- **Same API with Gebweb MVC:** [gebweb-101](https://github.com/iammikek/gebweb-101) (8014) — decorator controllers, `@Auth`, `/docs`
- **Compare minimal API-only backends:** [flask-101](https://github.com/iammikek/flask-101) (8011) or [express-101](https://github.com/iammikek/express-101) (8007) + geblang-101
- **Compare typed scripting vs Go:** [go-101](https://github.com/iammikek/go-101) vs geblang-101 (Geblang runs on a Go VM)
- **Pair with a client:** [react-101](https://github.com/iammikek/react-101), [vue-101](https://github.com/iammikek/vue-101), [alpine-101](https://github.com/iammikek/alpine-101), or [flutter-101](https://github.com/iammikek/flutter-101)

Catalogue: [automica.io/learning-101](https://automica.io/learning-101.html)

## Quick Reference

| Goal | Command |
|------|---------|
| Copy env | `cp .env.example .env` |
| Run local | `make serve` → http://127.0.0.1:8013 |
| Run via Docker image | `make serve-docker` |
| Run tests | `make test` / `make test-docker` |
| Static check | `make check` |
| Docker Compose | `docker compose up --build` |

# SOAR Base – Flight Club Management System

SOAR Base is a comprehensive Rails-based web application built to manage soaring glider club operations. It handles aircraft reservations (club flights, tow flights, CFI instruction, and commercial), flight logging, user management, membership administration, payment processing via Stripe, and administrative operations for flight club staff.

Whether you're managing an active soaring club or developing new features, this README covers everything from local development setup to production deployment.

---

## Table of Contents

1. [Features Overview](#features-overview)
2. [Technology Stack](#technology-stack)
3. [Getting Started (Developer Setup)](#getting-started--developer-setup)
4. [Project Structure](#project-structure)
5. [Configuration](#configuration)
6. [Development & Testing](#development--testing)
7. [Deployment (Production)](#deployment-production)
8. [Contributing & Support](#contributing--support)

---

## Features Overview

### Flight Reservations
- **Club Flights** – Standard member reservations for aircraft
- **Tow Flights** – Coordinate tow plane operations with fee tracking
- **CFI (Flight Instructor) Flights** – Instruction sessions with instructor assignment
- **Commercial Flights** – External or paid commercial operations

### Aircraft Management
- Inventory tracking for multiple aircraft types (club, private, towplane, instructor, commercial)
- Aircraft status and availability management
- Aircraft-user associations for roles and permissions

### User & Role System
- Comprehensive member profiles with role-based access control
- Roles: Pilots, Instructors, Tow Pilots, Administrators
- Email-based account activation and authentication
- Password reset workflow

### Membership Management
- Flexible membership tier creation and administration
- User membership tracking and lifecycle management
- Membership-based access controls

### Flight Logging & Tracking
- Detailed flight records with duration, tow height, landing notes
- Tow service tracking and height-based fees
- Flight status management (completed, canceled, pending)
- Historical flight analytics

### Payment Processing
- **Stripe Integration** – Secure payment handling for flights, memberships, and tow fees
- **Digital Receipts** – Automated receipt generation and delivery
- Payment status tracking and billing management
- Subscription management for memberships

### Administrative Dashboard
- Centralized admin interface for:
  - Reservation management and approvals
  - User and permission administration
  - Aircraft inventory management
  - Tow pilot and instructor scheduling
  - Financial reporting and fee management

### Communication & Notifications
- Email notifications via SendGrid
- Account activation emails
- Password reset communications
- Field status updates and club announcements
- Email request system for member-to-admin communication

### Background Job Processing
- **Sidekiq** integration for asynchronous tasks:
  - Email delivery
  - Payment processing
  - Scheduled tasks
  - Data synchronization

---

## Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Language** | Ruby | 3.2.3 |
| **Framework** | Rails | 7.0.7+ |
| **Database** | SQLite (dev) / PostgreSQL (prod) | Latest |
| **Web Server** | Puma | ~5.0 |
| **Asset Pipeline** | Sprockets + Importmap | — |
| **CSS Framework** | Bootstrap | — |
| **Frontend JS** | Hotwire (Turbo + Stimulus) | — |
| **Payment** | Stripe + Rails Pay | ~6.0 |
| **Background Jobs** | Sidekiq | — |
| **Email** | SendGrid (prod) | — |
| **Authentication** | bcrypt + Sessions | ~3.1.7 |
| **Testing** | Capybara + system tests | — |

**Key Dependencies:**
- `pay` – Payment processing abstractions
- `receipts` – PDF receipt generation
- `bootstrap` – UI framework
- `turbo-rails` – SPA-like navigation
- `stimulus-rails` – Lightweight JS framework
- `will_paginate` – Pagination helper
- `sid_scheduler` – Scheduled background jobs

---

## Getting Started (Developer Setup)

### Prerequisites

Ensure you have installed:
- **Ruby 3.2.3** (use [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/) for management)
- **Bundler** – `gem install bundler`
- **SQLite3** – Usually pre-installed; verify with `sqlite3 --version`
- **Node.js** – For asset compilation (via Importmap)
- **Git**

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/soar_base.git
cd soar_base
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Setup JavaScript packages (if needed)
bin/importmap pin
```

### 3. Database Setup

```bash
# Create databases
bin/rails db:create

# Run migrations
bin/rails db:migrate

# Seed with sample data (optional)
bin/rails db:seed
```

### 4. Credentials & Environment Setup

Rails uses encrypted credentials (`config/credentials.yml.enc`). To manage credentials:

```bash
# Edit credentials in your default editor
EDITOR=nano bin/rails credentials:edit
```

Add the following keys (minimally for local dev):

```yaml
stripe:
  secret_key: your_stripe_test_secret_key
  public_key: your_stripe_test_public_key

sendgrid:
  api_key: your_sendgrid_api_key  # Optional in development

recaptcha:
  site_key: your_recaptcha_site_key
  secret_key: your_recaptcha_secret_key
```

### 5. Start the Development Server

```bash
# Using foreman (requires Procfile.dev configuration)
foreman start -f Procfile.dev

# OR run Rails server directly
bin/rails server   # Runs on http://localhost:3000
```

### 6. Verify Setup

Visit `http://localhost:3000` in your browser. You should see the SOAR Base home page.

#### Running Tests

```bash
# Run all tests
bin/rails test

# Run with verbose output
bin/rails test --verbose

# Run a specific test file
bin/rails test test/controllers/reservations_controller_test.rb

# Run system tests (feature tests)
bin/rails test:system
```

---

## Project Structure

```
soar_base/
├── app/
│   ├── channels/              # WebSocket channels (Action Cable)
│   ├── controllers/           # Request handlers (reservations, flights, users, etc.)
│   ├── helpers/               # View helper methods
│   ├── javascript/            # Front-end JavaScript
│   ├── jobs/                  # Sidekiq background jobs
│   ├── mailers/               # Email templates and delivery
│   ├── models/                # Active Record models (User, Flight, Reservation, etc.)
│   ├── sidekiq/               # Sidekiq configuration and middleware
│   └── views/                 # ERB templates (flights, reservations, admin, etc.)
├── config/
│   ├── environments/          # Environment-specific settings (dev, test, prod)
│   ├── initializers/          # Gem and app initialization scripts
│   ├── locales/               # i18n translations
│   ├── application.rb         # Main app configuration
│   ├── database.yml           # Database adapter config
│   ├── routes.rb              # URL routing definitions
│   ├── sidekiq.yml            # Sidekiq queue configuration
│   └── credentials.yml.enc    # Encrypted secrets (Stripe, SendGrid, etc.)
├── db/
│   ├── migrate/               # Database migration files
│   ├── schema.rb              # Current database schema
│   └── seeds.rb               # Seed data for development
├── lib/
│   ├── tasks/                 # Custom Rake tasks
│   └── *.rb                   # Library code and utilities
├── test/
│   ├── controllers/           # Controller tests
│   ├── fixtures/              # Test data fixtures
│   ├── helpers/               # Helper method tests
│   ├── integration/           # Integration tests
│   ├── models/                # Model unit tests
│   ├── system/                # System/feature tests
│   └── test_helper.rb         # Test configuration
├── public/                    # Static files (robots.txt, 404/500 pages)
├── Gemfile                    # Ruby gem dependencies
├── Procfile                   # Production process manager config
├── Procfile.dev               # Development process manager config
├── config.ru                  # Rack app configuration
└── README.md                  # This file
```

### Key Models & Associations

- **User** – System users (pilots, instructors, admins)
- **Aircraft** – Aircraft inventory
- **Reservation** – Flight bookings (club, tow, CFI, commercial variants)
- **Flight** – Completed flight records linked to reservations
- **Tow** – Tow plane operation records
- **Membership** – Membership tier definitions
- **MembershipUser** – User membership status and dates
- **Permission** – Role-based permissions associated with users

---

## Configuration

### Database Configuration

Configure database adapters in [config/database.yml](config/database.yml):

- **Development**: SQLite3 (lightweight, file-based)
- **Test**: SQLite3 (isolated, discarded after tests)
- **Production**: PostgreSQL (recommended for reliability and concurrency)

To use PostgreSQL in production, ensure the `pg` gem is installed (included in Gemfile for production group).

### Stripe Integration

1. **Obtain API Keys:**
   - Log in to your Stripe Dashboard
   - Navigate to Developers > API keys
   - Copy the Test Secret Key and Test Publishable Key

2. **Add to Credentials:**
   ```bash
   EDITOR=nano bin/rails credentials:edit
   ```
   ```yaml
   stripe:
     secret_key: sk_test_xxxxx
     public_key: pk_test_xxxxx
   ```

3. **Webhook Handling:**
   - Set up a webhook endpoint in the Stripe Dashboard pointing to `https://yourdomain.com/webhooks/stripe`
   - Webhook events (e.g., `payment_intent.succeeded`) are handled by [app/controllers/webhooks/stripe_controller.rb](app/controllers/webhooks/stripe_controller.rb)

### Email Configuration (SendGrid)

In production, emails are sent via SendGrid:

1. **SendGrid Setup:**
   - Create a SendGrid account and generate an API key
   - Add to credentials:
     ```yaml
     sendgrid:
       api_key: SG.xxxxx
     ```

2. **Email Settings:**
   - Configure sender email, reply-to, and other settings in [config/environments/production.rb](config/environments/production.rb)

In development, emails are logged to console by default (or use a service like Mailhog for previewing).

### Sidekiq Background Jobs

Configure background job queues in [config/sidekiq.yml](config/sidekiq.yml):

```yaml
:concurrency: 5
:max_retries: 25
:timeout: 25

:queues:
  - [default, 1]
  - [mailers, 5]
  - [payments, 3]
```

To start Sidekiq workers:
```bash
bundle exec sidekiq -c 5 -v
```

Or use Procfile for automatic startup:
```bash
foreman start -f Procfile.dev
```

### Environment Variables

Configure these in your shell or `.env` file (locally):

- `RAILS_ENV=production|development|test`
- `RAILS_MASTER_KEY` – Key to decrypt credentials.yml.enc
- `RAILS_LOG_LEVEL=debug|info|warn|error`
- `STRIPE_WEBHOOK_SECRET` – Stripe webhook signing secret

---

## Development & Testing

### Running the Test Suite

```bash
# Run all tests
bin/rails test

# Run specific test directory
bin/rails test test/models/

# Run with profiling
bin/rails test -- --profile

# Run system/integration tests
bin/rails test:system
```

### Database Seeding

Generate sample data for development using the comprehensive seed script in [db/seeds.rb](db/seeds.rb).

#### Quick Start (Fresh Database)

```bash
# Reset everything (cleanest for development)
bin/rails db:reset
```

This runs in sequence:
- `db:drop` – Destroys the database
- `db:create` – Creates a fresh database  
- `db:migrate` – Runs all migrations
- `db:seed` – Loads seed data

After ~10-30 seconds, your database will be fully populated!

#### If You Already Have a Database

```bash
# Keep existing data, just run seeds (safe to run multiple times)
bin/rails db:seed
```

Uses `find_or_create_by` to avoid duplicates when re-running.

#### Verify Seeding Worked

```bash
# Start Rails console
bin/rails console

# Check users created
User.count                          # Should show 6+
User.all.map { |u| "#{u.username} - #{u.email}" }

# Check aircraft
Aircraft.all.map { |a| a.name }

# Check memberships  
Membership.all.map { |m| m.membership_type }

# Exit console
exit
```

#### Start the Server & Test Login

```bash
bin/rails server
```

Visit `http://localhost:3000` in your browser and log in with test accounts:

| Account | Email | Password |
|---------|-------|----------|
| Admin | `admin@soarclub.local` | `admin_secure_password_123` |
| Pilot | `pilot1@soarclub.local` | `test_password_123` |
| Instructor | `instructor@soarclub.local` | `test_password_123` |

#### What Gets Created

- 2 admin users (full system access)
- 4 pilot test users (pilots, instructor, tow pilot)
- User profiles with contact/emergency info
- 6 aircraft (club, tow, instructor, commercial types)
- 4 membership tiers (Student, Full Member, Trial, Instructor)
- User memberships assigned
- 90 days of operational calendar (weekdays only)

#### For Production Deployment

**Before first deployment:** Customize [db/seeds.rb](db/seeds.rb) with real data (your club's admin emails, actual aircraft, real memberships). Commit to git.

```bash
# On production server
ssh user@your-production-server
cd /var/www/soar_base

# Populate database (first time only)
RAILS_ENV=production bin/rails db:create
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails db:seed
```

⚠️ **Future deployments:** Only run migrations (`bin/rails db:migrate`). Don't re-seed unless you want to reset data.

#### Customization

Edit [db/seeds.rb](db/seeds.rb) to customize for your club:

- **Admin users** – Replace test emails with real admin emails
- **Test pilots** – Update with your staff names
- **Aircraft** – Change tail numbers to your actual aircraft (`N12345` → real IDs)
- **Memberships** – Adjust types and pricing for your club
- **Operational days** – Modify if your club operates weekends, specific days, etc.

**Example: Add 100 test pilots for load testing:**

```ruby
# Add to db/seeds.rb STEP 3
100.times do |n|
  User.find_or_create_by(email: "testpilot#{n}@soarclub.local") do |u|
    u.username = "testpilot#{n}"
    u.password = "test_password_123"
    u.password_confirmation = "test_password_123"
    u.first_name = Faker::Name.first_name
    u.last_name = Faker::Name.last_name
    u.activated = true
    u.activated_at = Time.zone.now
  end
end
```

### Debugging

Use the `debug` gem for interactive breakpoints:

```ruby
# In your code
debugger  # Execution pauses here; type commands like `n` (next), `c` (continue), `s` (step)
```

Or use byebug:

```ruby
byebug
```

### Code Quality & Linting

If a linter is configured (e.g., RuboCop), run:

```bash
bundle exec rubocop           # Check style violations
bundle exec rubocop -a        # Auto-fix violations
```

---

## Deployment (Production)

### Server Requirements

- **OS**: Linux (Ubuntu 20.04 LTS recommended) or macOS
- **Ruby**: 3.2.3+ (matching Gemfile)
- **PostgreSQL**: 12+
- **Redis**: 5+ (optional, for caching and Action Cable)
- **Node.js**: 16+ (for asset compilation, if not precompiled)
- **Bundler**: Latest

### Environment Setup

1. **Clone Repository:**
   ```bash
   git clone https://github.com/your-org/soar_base.git /var/www/soar_base
   cd /var/www/soar_base
   ```

2. **Install Dependencies:**
   ```bash
   bundle install --deployment --without development:test
   ```

3. **Credentials:**
   Set the Rails master key as an environment variable:
   ```bash
   export RAILS_MASTER_KEY=your_master_key_here
   ```

4. **Database Setup:**
   ```bash
   RAILS_ENV=production bin/rails db:create
   RAILS_ENV=production bin/rails db:migrate
   ```

5. **Precompile Assets:**
   ```bash
   RAILS_ENV=production bin/rails assets:precompile
   ```

### Running the Application

#### Option 1: Traditional Server + Sidekiq (Recommended)

**Puma Web Server:**
```bash
RAILS_ENV=production bin/rails server -b 0.0.0.0 -p 3000 -w 2
```

**Sidekiq Workers (separate process):**
```bash
RAILS_ENV=production bundle exec sidekiq -c 10 -v
```

#### Option 2: Process Manager (Foreman/Systemd)

Use Procfile and process manager:
```bash
foreman start
```

Or create systemd services for Rails and Sidekiq.

### Database Migrations

Run migrations safely in production:

```bash
# Backup first
pg_dump -U postgres soar_base_prod > backup_$(date +%Y%m%d).sql

# Run migrations
RAILS_ENV=production bin/rails db:migrate

# Restart application
systemctl restart soar_base  # or your process manager
```

### Deployment Platforms

**Recommended Options:**

1. **Heroku** – Easiest for small/medium apps
   - Push code: `git push heroku main`
   - Database: Heroku Postgres (managed)
   - Sidekiq: Heroku Redis add-on
   - Procfile: Automatically recognized

2. **AWS (EC2 + RDS)** – More control and scale
   - EC2 for application server
   - RDS for PostgreSQL
   - ElastiCache for Redis
   - Use systemd for process management

3. **DigitalOcean / Linode** – Affordable VPS
   - Single droplet with PostgreSQL and Redis
   - Use Nginx as reverse proxy
   - Systemd for process management

4. **Docker** – Containerized deployment
   - Create `Dockerfile` for Rails app
   - Use `docker-compose` for services (PostgreSQL, Redis, Sidekiq)
   - Deploy to Docker host, Kubernetes, or cloud platforms

### Monitoring & Logging

- **Logs**: Check Rails logs in `log/production.log`
- **Sidekiq Web UI**: Access at `/sidekiq` (requires authentication)
- **Error Tracking**: Consider integrating Sentry, Rollbar, or New Relic
- **Uptime Monitoring**: Use services like UptimeRobot or Pingdom

### SSL/HTTPS

Use Let's Encrypt via Certbot:

```bash
sudo certbot certonly --standalone -d yourdomain.com
```

Configure Nginx or Rails to serve HTTPS.

---

## Contributing & Support

### Reporting Issues

To report bugs or request features:

1. Check existing [GitHub Issues](https://github.com/your-org/soar_base/issues)
2. Open a new issue with:
   - **Title**: Clear, concise description
   - **Description**: Environment setup, steps to reproduce, actual vs. expected behavior
   - **Logs/Screenshots**: Any relevant error messages or screenshots

### Development Workflow

1. **Fork** the repository
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make changes** and commit: `git commit -m "Add descriptive message"`
4. **Push to branch**: `git push origin feature/your-feature-name`
5. **Open a Pull Request** with a clear description

### Code Style

Follow Rails conventions:
- Indentation: 2 spaces
- File names: `snake_case`
- Class names: `CamelCase`
- Method names: `snake_case`
- Use helpful comments for complex logic

### Club Administration Support

For operational support (reservations, memberships, billing):

- **Email**: admin@yourclub.com
- **Admin Dashboard**: `/admin` (requires admin role)
- **Documentation**: Refer to in-app club documentation

---

**For more information, see:**
- [Rails Guides](https://guides.rubyonrails.org/)
- [Stripe Documentation](https://stripe.com/docs)
- [Sidekiq Documentation](https://github.com/mperham/sidekiq/wiki)

---

*Last updated: April 2026*

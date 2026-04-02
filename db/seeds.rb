# SOAR Base Database Seeder
# This file populates the database with initial data for quick deployment
# Run with: bin/rails db:seed
# Or reset and reseed: bin/rails db:reset (WARNING: destructive)

puts "🌱 Seeding SOAR Base database..."

# ============================================================================
# STEP 1: Clear existing data (optional - comment out for production)
# ============================================================================
# Uncomment the following to reset all data during development:
# [Permission, Profile, MembershipUser, Membership, Flight, Tow, Reservation, 
#  AircraftUser, Aircraft, Day, User].each(&:delete_all)
# puts "✓ Cleared existing data"

# ============================================================================
# STEP 2: Create Admin Users
# ============================================================================
admin_users = [
  {
    username: "admin",
    email: "admin@soarclub.local",
    password: "admin_secure_password_123",
    status: 'active',
  },
  {
    username: "ops_manager",
    email: "ops@soarclub.local",
    password: "ops_secure_password_456",
    status: 'active',
  },
   {
    username: "nathan",
    email: "nathan@example.com",
    password: "password",
    status: 'active',
  }
]

admin_users.each do |attrs|
  user = User.find_or_create_by(email: attrs[:email]) do |u|
    u.username = attrs[:username]
    u.password = attrs[:password]
    u.password_confirmation = attrs[:password]
    u.activated = true
    u.activated_at = Time.zone.now
    u.status = attrs[:status]
  end
  puts "✓ Admin user created: #{user.username} (#{user.email})"
end

# ============================================================================
# STEP 3: Create Pilot Test Users
# ============================================================================
pilot_users = [
  { username: "pilot1", email: "pilot1@soarclub.local" },
  { username: "pilot2", email: "pilot2@soarclub.local" },
  { username: "instructor1", email: "instructor@soarclub.local" },
  { username: "towpilot1", email: "towpilot@soarclub.local" }
]

pilot_users.each do |attrs|
  user = User.find_or_create_by(email: attrs[:email]) do |u|
    u.username = attrs[:username]
    u.password = "test_password_123"
    u.password_confirmation = "test_password_123"
    u.activated = true
    u.activated_at = Time.zone.now
    u.status = 'active'
  end
  puts "✓ Pilot user created: #{user.username}"
end

# ============================================================================
# STEP 4: Create Permissions for Users
# ============================================================================
admin_user = User.find_by(username: "admin")
nathan_user = User.find_by(username: "nathan")
ops_manager = User.find_by(username: "ops_manager")
pilot_1 = User.find_by(username: "pilot1")
instructor = User.find_by(username: "instructor1")
towpilot = User.find_by(username: "towpilot1")

# Admin permissions (full access)
Permission.find_or_create_by(user_id: admin_user.id) do |p|
  p.user_admin = true
  p.club_admin = true
  p.site_admin = true
  p.global_admin = true
  p.instructor = true
  p.towpilot = true
  p.commercial = true
end
puts "✓ Admin permissions assigned"

# Nathan permissions (full access)
Permission.find_or_create_by(user_id: nathan_user.id) do |p|
  p.user_admin = true
  p.club_admin = true
  p.site_admin = true
  p.global_admin = true
  p.instructor = true
  p.towpilot = true
  p.commercial = true
end
puts "✓ Nathan permissions assigned"

# Ops manager permissions (club admin, no site admin)
Permission.find_or_create_by(user_id: ops_manager.id) do |p|
  p.user_admin = true
  p.club_admin = true
  p.site_admin = false
  p.global_admin = false
  p.instructor = false
  p.towpilot = false
  p.commercial = false
end
puts "✓ Operations manager permissions assigned"

# Regular pilot (no special permissions)
Permission.find_or_create_by(user_id: pilot_1.id) do |p|
  p.user_admin = false
  p.club_admin = false
  p.site_admin = false
  p.global_admin = false
  p.instructor = false
  p.towpilot = false
  p.commercial = false
end

# Instructor
Permission.find_or_create_by(user_id: instructor.id) do |p|
  p.user_admin = false
  p.club_admin = false
  p.site_admin = false
  p.global_admin = false
  p.instructor = true
  p.towpilot = false
  p.commercial = false
end

# Tow pilot
Permission.find_or_create_by(user_id: towpilot.id) do |p|
  p.user_admin = false
  p.club_admin = false
  p.site_admin = false
  p.global_admin = false
  p.instructor = false
  p.towpilot = true
  p.commercial = false
end
puts "✓ User permissions assigned (pilot, instructor, tow pilot)"

# ============================================================================
# STEP 5: Create User Profiles
# ============================================================================
User.all.each do |user|
  profile = Profile.find_or_create_by(user_id: user.id) do |p|
    p.phone_number = "555-000-#{rand(1000..9999)}"
    p.emergency_contact = "Emergency Contact for #{user.username}"
    p.emergency_phone = "555-100-#{rand(1000..9999)}"
    p.date_of_birth = (18..65).to_a.sample.years.ago
    p.street_first_line = "#{rand(100..9999)} Main St"
    p.city = "Anytown"
    p.state = "CA"
    p.zip = "90210"
  end
end
puts "✓ User profiles created (#{User.count} profiles)"

# ============================================================================
# STEP 6: Create Aircraft
# ============================================================================
aircrafts = [
  { name: "N12345", short_name: "1-2", group: "club", last_maintenance: 30.days.ago },   # club
  { name: "N23456", short_name: "2-3", group: "club", last_maintenance: 45.days.ago },   # club
  { name: "N34567", short_name: "3-4", group: "private", last_maintenance: 15.days.ago },   # private
  { name: "N45678", short_name: "T-1", group: "towplane", last_maintenance: 60.days.ago },   # towplane
  { name: "N56789", short_name: "I-1", group: "club", last_maintenance: 20.days.ago },   # club
  { name: "N67890", short_name: "C-1", group: "club", last_maintenance: 10.days.ago },   # club
]

aircrafts.each do |attrs|
  aircraft = Aircraft.find_or_create_by(name: attrs[:name]) do |a|
    a.short_name = attrs[:short_name]
    a.group = attrs[:group]
    a.last_maintenance = attrs[:last_maintenance]
    a.active_flag = true
  end
  puts "✓ Aircraft created: #{aircraft.name} (#{aircraft.short_name})"
end

# ============================================================================
# STEP 7: Create Memberships
# ============================================================================
memberships = [
  { membership_type: "Student", renewal_period: 365, renewal_price: 50000, active_flag: true },
  { membership_type: "Full Member", renewal_period: 365, renewal_price: 120000, active_flag: true },
  { membership_type: "Trial", renewal_period: 30, renewal_price: 15000, active_flag: true },
  { membership_type: "Instructor", renewal_period: 365, renewal_price: 80000, active_flag: true },
]

memberships.each do |attrs|
  membership = Membership.find_or_create_by(membership_type: attrs[:membership_type]) do |m|
    m.renewal_period = attrs[:renewal_period]
    m.renewal_price = attrs[:renewal_price]
    m.active_flag = attrs[:active_flag]
  end
  puts "✓ Membership created: #{membership.membership_type} ($#{membership.renewal_price}/#{membership.renewal_period}d)"
end

# ============================================================================
# STEP 8: Assign Memberships to Pilots
# ============================================================================
full_membership = Membership.find_by(membership_type: "Full Member")
instructor_membership = Membership.find_by(membership_type: "Instructor")

User.where(username: ["pilot1", "pilot2"]).each do |user|
  MembershipUser.find_or_create_by(user_id: user.id) do |mu|
    mu.membership = full_membership
    mu.joined_date = 6.months.ago.to_date
    mu.renewal_date = 6.months.from_now.to_date
    mu.active_flag = true
  end
end

instructor_user = User.find_by(username: "instructor1")
if instructor_user
  MembershipUser.find_or_create_by(user_id: instructor_user.id) do |mu|
    mu.membership = instructor_membership
    mu.joined_date = 1.year.ago.to_date
    mu.renewal_date = 1.month.from_now.to_date
    mu.active_flag = true
  end
end
puts "✓ User memberships assigned"

# ============================================================================
# STEP 9: Create Operational Days
# ============================================================================
# Create operational days for the next 90 days (skip weekends)
(0..90).each do |n|
  date = n.days.from_now
  # Skip Saturdays (6) and Sundays (0)
  next if [0, 6].include?(date.wday)
  
  Day.find_or_create_by(day: date.to_date) do |d|
    d.active_flag = true
  end
end
puts "✓ Operational days created for next 90 days (weekdays only)"

# ============================================================================
# STEP 10: Create Operating Hours
# ============================================================================
operating_hours = [
  "9AM",
  "10AM",
  "11AM",
  "12PM",
  "1PM",
  "2PM",
  "3PM",
  "4PM",
  "5PM",
  "6PM",
]

operating_hours.each do |hour|
  Hour.find_or_create_by(hour: hour) do |h|
    h.active_flag = true
  end
  puts "✓ Operating hour created: #{hour}"
end
puts "✓ Operating hours created (9am - 6pm)"

# ============================================================================
# STEP 11: Create Sample Reservations & Flights (Optional)
# ============================================================================
# Uncomment to create sample reservation data

# aircraft_club = Aircraft.find_by(short_name: "1-2")
# user = User.find_by(username: "pilot1")
# tomorrow = 1.day.from_now.to_date
# 
# # Create a club flight reservation
# reservation = Reservation.find_or_create_by(
#   user_id: user.id,
#   aircraft_id: aircraft_club.id,
#   reservation_date: tomorrow
# ) do |r|
#   r.reservation_time = "09:00"
#   r.reservation_type = 0  # club flight
#   r.status = 0  # pending
# end
# 
# # Create a completed flight from yesterday
# if Day.exists?(day: 1.day.ago.to_date)
#   flight = Flight.find_or_create_by(
#     user_id: user.id,
#     aircraft_id: aircraft_club.id,
#     flight_date: 1.day.ago.to_date
#   ) do |f|
#     f.flight_time = "09:15"
#     f.duration = 1.5
#     f.tow_height = 2500
#     f.fees = 45.00
#     f.status = 1  # completed
#   end
# end
# puts "✓ Sample reservations and flights created"

puts "\n✅ Database seeding complete!"
puts "👤 Admin: admin@soarclub.local / password: admin_secure_password_123"
puts "👤 Test pilots: pilot1@soarclub.local, pilot2@soarclub.local / password: test_password_123"
puts "📅 Operational days: Weekdays for the next 90 days"
puts "\n⚠️  IMPORTANT: Change all test passwords in production!"
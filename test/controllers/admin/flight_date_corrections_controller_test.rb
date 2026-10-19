require "test_helper"

class Admin::FlightDateCorrectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = create_user("Date Admin", "date-admin@example.com", user_admin: true)
    @member = create_user("Date Member", "date-member@example.com")
    @instructor = create_user("Date Instructor", "date-instructor@example.com", instructor: true)
    @aircraft = Aircraft.create!(name: "Correction Glider", short_name: "CG", group: "club", active_flag: true)
    @reservation = create_reservation(@member, @aircraft, Date.new(2026, 10, 10), "10am")
    @flight = create_flight(@reservation, @member, Date.new(2026, 10, 10))
    @sibling_flight = create_flight(@reservation, @member, Date.new(2026, 10, 10))
    @tow = Tow.create!(reservation: @reservation, user: @member, aircraft: @aircraft, tow_date: Date.new(2026, 10, 10), tows: 3, releases: 0, tach_start: 10.0, tach_end: 11.0)
  end

  test "user admin can open date correction form" do
    sign_in(@admin)

    get edit_admin_flight_date_correction_path(@flight)

    assert_response :success
    assert_select "input[name='date_correction[reservation_date]']"
    assert_select "input[name='date_correction[flight_date]']"
  end

  test "admin flights page renders date correction actions for each flight" do
    sign_in(@admin)

    get "/admin/flights"

    assert_response :success
    assert_select "a[href='#{edit_admin_flight_date_correction_path(@flight)}']", text: "Correct dates", minimum: 1
  end

  test "anonymous visitor is redirected to login" do
    get edit_admin_flight_date_correction_path(@flight)

    assert_redirected_to login_path
  end

  test "non-admin cannot correct dates" do
    sign_in(@member)

    patch admin_flight_date_correction_path(@flight), params: {
      date_correction: { reservation_date: "2026-10-12", flight_date: "2026-10-12" }
    }

    assert_redirected_to reservations_url
    assert_equal Date.new(2026, 10, 10), @reservation.reload.reservation_date
    assert_equal Date.new(2026, 10, 10), @flight.reload.flight_date
  end

  test "reservation date change cascades to every flight and tow" do
    sign_in(@admin)

    patch admin_flight_date_correction_path(@flight), params: {
      date_correction: { reservation_date: "2026-10-12", flight_date: "2026-10-13" }
    }

    assert_redirected_to admin_flights_path
    assert_equal Date.new(2026, 10, 12), @reservation.reload.reservation_date
    assert_equal Date.new(2026, 10, 12), @flight.reload.flight_date
    assert_equal Date.new(2026, 10, 12), @sibling_flight.reload.flight_date
    assert_equal Date.new(2026, 10, 12), @tow.reload.tow_date
  end

  test "flight date can be corrected without changing reservation or siblings" do
    sign_in(@admin)

    patch admin_flight_date_correction_path(@flight), params: {
      date_correction: { reservation_date: "2026-10-10", flight_date: "2026-10-11" }
    }

    assert_redirected_to admin_flights_path
    assert_equal Date.new(2026, 10, 10), @reservation.reload.reservation_date
    assert_equal Date.new(2026, 10, 11), @flight.reload.flight_date
    assert_equal Date.new(2026, 10, 10), @sibling_flight.reload.flight_date
    assert_equal Date.new(2026, 10, 10), @tow.reload.tow_date
  end

  test "reservation date wins when both dates change" do
    sign_in(@admin)

    patch admin_flight_date_correction_path(@flight), params: {
      date_correction: { reservation_date: "2026-10-12", flight_date: "2026-10-14" }
    }

    assert_equal Date.new(2026, 10, 12), @flight.reload.flight_date
  end

  test "invalid dates leave all records unchanged" do
    sign_in(@admin)

    patch admin_flight_date_correction_path(@flight), params: {
      date_correction: { reservation_date: "not-a-date", flight_date: "2026-10-12" }
    }

    assert_response :unprocessable_entity
    assert_equal Date.new(2026, 10, 10), @reservation.reload.reservation_date
    assert_equal Date.new(2026, 10, 10), @flight.reload.flight_date
    assert_equal Date.new(2026, 10, 10), @sibling_flight.reload.flight_date
    assert_equal Date.new(2026, 10, 10), @tow.reload.tow_date
  end

  test "conflicting reservation date rolls back the entire cascade" do
    create_reservation(create_user("Other Member", "other-member@example.com"), @aircraft, Date.new(2026, 10, 12), "10am")
    sign_in(@admin)

    patch admin_flight_date_correction_path(@flight), params: {
      date_correction: { reservation_date: "2026-10-12", flight_date: "2026-10-12" }
    }

    assert_response :unprocessable_entity
    assert_equal Date.new(2026, 10, 10), @reservation.reload.reservation_date
    assert_equal Date.new(2026, 10, 10), @flight.reload.flight_date
    assert_equal Date.new(2026, 10, 10), @sibling_flight.reload.flight_date
    assert_equal Date.new(2026, 10, 10), @tow.reload.tow_date
  end

  private

  def create_user(username, email, user_admin: false, instructor: false)
    user = User.create!(
      username: username,
      email: email,
      password: "password",
      password_confirmation: "password",
      activated: true
    )
    user.create_permission!(user_admin: user_admin, instructor: instructor)
    user
  end

  def create_reservation(user, aircraft, date, time)
    Reservation.create!(
      user: user,
      aircraft: aircraft,
      reservation_date: date,
      reservation_time: time,
      reservation_duration: 60,
      instructor_flag: false,
      rth_flag: false,
      status: "open"
    )
  end

  def create_flight(reservation, user, date)
    Flight.create!(
      reservation: reservation,
      user: user,
      aircraft: reservation.aircraft,
      flight_date: date,
      flight_time: 20,
      tow_height: 200,
      rope_break: false,
      fees: 0
    )
  end

  def sign_in(user)
    post login_path, params: { session: { email: user.email, password: "password" } }
  end
end
json.extract! tow, :id, :reservation_id, :tow_date, :aircraft_id, :tows, :releases, :tach_end, :fuel_added, :oil_added, :created_at, :updated_at
json.url tow_url(tow, format: :json)

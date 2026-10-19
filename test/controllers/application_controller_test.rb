require "test_helper"

class ReturnPathProbeController < ApplicationController
  def show
    redirect_to return_path("/reservations")
  end
end

class ReturnPathControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.routes.draw do
      get "/return_path_probe", to: "return_path_probe#show"
    end
  end

  teardown do
    Rails.application.reload_routes!
  end

  test "return path preserves a local query string" do
    get "/return_path_probe", params: { return_to: "/reservations/tow?page=3" }

    assert_redirected_to "/reservations/tow?page=3"
  end

  test "return path falls back for an external URL" do
    get "/return_path_probe", params: { return_to: "https://attacker.example/phish" }

    assert_redirected_to "/reservations"
  end

  test "return path uses a same-host referrer if no explicit path is supplied" do
    get "/return_path_probe", headers: { "HTTP_REFERER" => "http://www.example.com/reservations/tow?page=2" }

    assert_redirected_to "/reservations/tow?page=2"
  end
end
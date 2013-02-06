require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  setup do
    @match = matches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:matches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create match" do
    assert_difference('Match.count') do
      post :create, match: { draws: @match.draws, p1_games_won: @match.p1_games_won, p2_games_won: @match.p2_games_won, player_1_id: @match.player_1_id, player_2_id: @match.player_2_id }
    end

    assert_redirected_to match_path(assigns(:match))
  end

  test "should show match" do
    get :show, id: @match
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @match
    assert_response :success
  end

  test "should update match" do
    put :update, id: @match, match: { draws: @match.draws, p1_games_won: @match.p1_games_won, p2_games_won: @match.p2_games_won, player_1_id: @match.player_1_id, player_2_id: @match.player_2_id }
    assert_redirected_to match_path(assigns(:match))
  end

  test "should destroy match" do
    assert_difference('Match.count', -1) do
      delete :destroy, id: @match
    end

    assert_redirected_to matches_path
  end
end

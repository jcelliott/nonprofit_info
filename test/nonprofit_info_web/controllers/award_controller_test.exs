defmodule NonprofitInfoWeb.AwardControllerTest do
  use NonprofitInfoWeb.ConnCase

  alias NonprofitInfo.Filings
  alias NonprofitInfo.Filings.Award

  @create_attrs %{
    amount: "some amount",
    purpose: "some purpose"
  }
  @update_attrs %{
    amount: "some updated amount",
    purpose: "some updated purpose"
  }
  @invalid_attrs %{amount: nil, purpose: nil}

  def fixture(:award) do
    {:ok, award} = Filings.create_award(@create_attrs)
    award
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all awards", %{conn: conn} do
      conn = get(conn, Routes.award_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create award" do
    test "renders award when data is valid", %{conn: conn} do
      conn = post(conn, Routes.award_path(conn, :create), award: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.award_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => "some amount",
               "purpose" => "some purpose"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.award_path(conn, :create), award: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update award" do
    setup [:create_award]

    test "renders award when data is valid", %{conn: conn, award: %Award{id: id} = award} do
      conn = put(conn, Routes.award_path(conn, :update, award), award: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.award_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => "some updated amount",
               "purpose" => "some updated purpose"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, award: award} do
      conn = put(conn, Routes.award_path(conn, :update, award), award: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete award" do
    setup [:create_award]

    test "deletes chosen award", %{conn: conn, award: award} do
      conn = delete(conn, Routes.award_path(conn, :delete, award))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.award_path(conn, :show, award))
      end
    end
  end

  defp create_award(_) do
    award = fixture(:award)
    %{award: award}
  end
end

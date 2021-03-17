defmodule NonprofitInfoWeb.FilingControllerTest do
  use NonprofitInfoWeb.ConnCase

  alias NonprofitInfo.Filings
  alias NonprofitInfo.Filings.Filing

  @create_attrs %{
    tax_year: 42
  }
  @update_attrs %{
    tax_year: 43
  }
  @invalid_attrs %{tax_year: nil}

  def fixture(:filing) do
    {:ok, filing} = Filings.create_filing(@create_attrs)
    filing
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all filings", %{conn: conn} do
      conn = get(conn, Routes.filing_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create filing" do
    test "renders filing when data is valid", %{conn: conn} do
      conn = post(conn, Routes.filing_path(conn, :create), filing: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.filing_path(conn, :show, id))

      assert %{
               "id" => id,
               "tax_year" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.filing_path(conn, :create), filing: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update filing" do
    setup [:create_filing]

    test "renders filing when data is valid", %{conn: conn, filing: %Filing{id: id} = filing} do
      conn = put(conn, Routes.filing_path(conn, :update, filing), filing: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.filing_path(conn, :show, id))

      assert %{
               "id" => id,
               "tax_year" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, filing: filing} do
      conn = put(conn, Routes.filing_path(conn, :update, filing), filing: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete filing" do
    setup [:create_filing]

    test "deletes chosen filing", %{conn: conn, filing: filing} do
      conn = delete(conn, Routes.filing_path(conn, :delete, filing))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.filing_path(conn, :show, filing))
      end
    end
  end

  defp create_filing(_) do
    filing = fixture(:filing)
    %{filing: filing}
  end
end

defmodule NonprofitInfoWeb.OrganizationControllerTest do
  use NonprofitInfoWeb.ConnCase

  alias NonprofitInfo.Filings
  alias NonprofitInfo.Filings.Organization

  @create_attrs %{
    address1: "some address1",
    address2: "some address2",
    city: "some city",
    ein: "some ein",
    name: "some name",
    state: "some state",
    zip_code: "some zip_code"
  }
  @update_attrs %{
    address1: "some updated address1",
    address2: "some updated address2",
    city: "some updated city",
    ein: "some updated ein",
    name: "some updated name",
    state: "some updated state",
    zip_code: "some updated zip_code"
  }
  @invalid_attrs %{address1: nil, address2: nil, city: nil, ein: nil, name: nil, state: nil, zip_code: nil}

  def fixture(:organization) do
    {:ok, organization} = Filings.create_organization(@create_attrs)
    organization
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all organizations", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn} do
      conn = post(conn, Routes.organization_path(conn, :create), organization: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.organization_path(conn, :show, id))

      assert %{
               "id" => id,
               "address1" => "some address1",
               "address2" => "some address2",
               "city" => "some city",
               "ein" => "some ein",
               "name" => "some name",
               "state" => "some state",
               "zip_code" => "some zip_code"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.organization_path(conn, :create), organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update organization" do
    setup [:create_organization]

    test "renders organization when data is valid", %{conn: conn, organization: %Organization{id: id} = organization} do
      conn = put(conn, Routes.organization_path(conn, :update, organization), organization: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.organization_path(conn, :show, id))

      assert %{
               "id" => id,
               "address1" => "some updated address1",
               "address2" => "some updated address2",
               "city" => "some updated city",
               "ein" => "some updated ein",
               "name" => "some updated name",
               "state" => "some updated state",
               "zip_code" => "some updated zip_code"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = put(conn, Routes.organization_path(conn, :update, organization), organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, Routes.organization_path(conn, :delete, organization))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.organization_path(conn, :show, organization))
      end
    end
  end

  defp create_organization(_) do
    organization = fixture(:organization)
    %{organization: organization}
  end
end

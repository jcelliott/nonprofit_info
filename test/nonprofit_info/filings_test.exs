defmodule NonprofitInfo.FilingsTest do
  use NonprofitInfo.DataCase

  alias NonprofitInfo.Filings

  describe "organizations" do
    alias NonprofitInfo.Filings.Organization

    @valid_attrs %{address1: "some address1", address2: "some address2", city: "some city", ein: "some ein", name: "some name", state: "some state", zip_code: "some zip_code"}
    @update_attrs %{address1: "some updated address1", address2: "some updated address2", city: "some updated city", ein: "some updated ein", name: "some updated name", state: "some updated state", zip_code: "some updated zip_code"}
    @invalid_attrs %{address1: nil, address2: nil, city: nil, ein: nil, name: nil, state: nil, zip_code: nil}

    def organization_fixture(attrs \\ %{}) do
      {:ok, organization} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Filings.create_organization()

      organization
    end

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Filings.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Filings.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} = Filings.create_organization(@valid_attrs)
      assert organization.address1 == "some address1"
      assert organization.address2 == "some address2"
      assert organization.city == "some city"
      assert organization.ein == "some ein"
      assert organization.name == "some name"
      assert organization.state == "some state"
      assert organization.zip_code == "some zip_code"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Filings.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{} = organization} = Filings.update_organization(organization, @update_attrs)
      assert organization.address1 == "some updated address1"
      assert organization.address2 == "some updated address2"
      assert organization.city == "some updated city"
      assert organization.ein == "some updated ein"
      assert organization.name == "some updated name"
      assert organization.state == "some updated state"
      assert organization.zip_code == "some updated zip_code"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Filings.update_organization(organization, @invalid_attrs)
      assert organization == Filings.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Filings.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Filings.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Filings.change_organization(organization)
    end
  end

  describe "awards" do
    alias NonprofitInfo.Filings.Award

    @valid_attrs %{amount: "some amount", purpose: "some purpose"}
    @update_attrs %{amount: "some updated amount", purpose: "some updated purpose"}
    @invalid_attrs %{amount: nil, purpose: nil}

    def award_fixture(attrs \\ %{}) do
      {:ok, award} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Filings.create_award()

      award
    end

    test "list_awards/0 returns all awards" do
      award = award_fixture()
      assert Filings.list_awards() == [award]
    end

    test "get_award!/1 returns the award with given id" do
      award = award_fixture()
      assert Filings.get_award!(award.id) == award
    end

    test "create_award/1 with valid data creates a award" do
      assert {:ok, %Award{} = award} = Filings.create_award(@valid_attrs)
      assert award.amount == "some amount"
      assert award.purpose == "some purpose"
    end

    test "create_award/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Filings.create_award(@invalid_attrs)
    end

    test "update_award/2 with valid data updates the award" do
      award = award_fixture()
      assert {:ok, %Award{} = award} = Filings.update_award(award, @update_attrs)
      assert award.amount == "some updated amount"
      assert award.purpose == "some updated purpose"
    end

    test "update_award/2 with invalid data returns error changeset" do
      award = award_fixture()
      assert {:error, %Ecto.Changeset{}} = Filings.update_award(award, @invalid_attrs)
      assert award == Filings.get_award!(award.id)
    end

    test "delete_award/1 deletes the award" do
      award = award_fixture()
      assert {:ok, %Award{}} = Filings.delete_award(award)
      assert_raise Ecto.NoResultsError, fn -> Filings.get_award!(award.id) end
    end

    test "change_award/1 returns a award changeset" do
      award = award_fixture()
      assert %Ecto.Changeset{} = Filings.change_award(award)
    end
  end

  describe "filings" do
    alias NonprofitInfo.Filings.Filing

    @valid_attrs %{tax_year: 42}
    @update_attrs %{tax_year: 43}
    @invalid_attrs %{tax_year: nil}

    def filing_fixture(attrs \\ %{}) do
      {:ok, filing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Filings.create_filing()

      filing
    end

    test "list_filings/0 returns all filings" do
      filing = filing_fixture()
      assert Filings.list_filings() == [filing]
    end

    test "get_filing!/1 returns the filing with given id" do
      filing = filing_fixture()
      assert Filings.get_filing!(filing.id) == filing
    end

    test "create_filing/1 with valid data creates a filing" do
      assert {:ok, %Filing{} = filing} = Filings.create_filing(@valid_attrs)
      assert filing.tax_year == 42
    end

    test "create_filing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Filings.create_filing(@invalid_attrs)
    end

    test "update_filing/2 with valid data updates the filing" do
      filing = filing_fixture()
      assert {:ok, %Filing{} = filing} = Filings.update_filing(filing, @update_attrs)
      assert filing.tax_year == 43
    end

    test "update_filing/2 with invalid data returns error changeset" do
      filing = filing_fixture()
      assert {:error, %Ecto.Changeset{}} = Filings.update_filing(filing, @invalid_attrs)
      assert filing == Filings.get_filing!(filing.id)
    end

    test "delete_filing/1 deletes the filing" do
      filing = filing_fixture()
      assert {:ok, %Filing{}} = Filings.delete_filing(filing)
      assert_raise Ecto.NoResultsError, fn -> Filings.get_filing!(filing.id) end
    end

    test "change_filing/1 returns a filing changeset" do
      filing = filing_fixture()
      assert %Ecto.Changeset{} = Filings.change_filing(filing)
    end
  end
end

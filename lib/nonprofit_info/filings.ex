defmodule NonprofitInfo.Filings do
  @moduledoc """
  The Filings context.
  """
  require Logger
  import Ecto.Query, warn: false
  alias NonprofitInfo.Repo
  alias NonprofitInfo.Filings.Organization
  alias NonprofitInfo.Filings.Filing
  alias NonprofitInfo.Filings.Award
  alias NonprofitInfo.Filings.Form990

  def insert_filing_data(:form_990, data) do
    filing_data = Form990.parse_form_990(:xml, data)

    with {:ok, filer} <- get_or_create_organization(filing_data.filer),
         {:ok, filing} <- create_filing(%{filer_id: filer.id, tax_year: filing_data.tax_year}) do
      insert_award_data(filing_data.awards, filer.id, filing.id)
      {:ok, filing}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def insert_award_data(awards, filer_id, filing_id) do
    Enum.each(awards, fn award ->
      case get_or_create_organization(award.recipient) do
        {:error, reason} ->
          Logger.warn("error creating organization for an award record: #{inspect(reason)}")

        {:ok, recipient} ->
          award
          |> Map.delete(:recipient)
          |> Map.put(:recipient_id, recipient.id)
          |> Map.put(:filer_id, filer_id)
          |> Map.put(:filing_id, filing_id)
          |> create_award()
      end
    end)
  end

  def process_form_url(url) do
    case HTTPoison.get(String.trim(url)) do
      {:ok, %{status_code: 200, body: body}} ->
        insert_filing_data(:form_990, body)

      {:ok, %{status_code: status_code}} ->
        Logger.warn("failed to fetch form: #{status_code}")
        {:error, "failed to fetch form data"}

      {:error, reason} ->
        Logger.warn("error fetching form: #{inspect(reason)}")
        {:error, "error fetching form data"}
    end
  end

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations do
    Repo.all(Organization)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id), do: Repo.get!(Organization, id)

  def get_organization_by_ein(ein) do
    case Repo.get_by(Organization, ein: ein) do
      nil -> {:error, "not found"}
      org -> {:ok, org}
    end
  end

  def organization_exists?(ein) do
    Repo.exists?(from o in Organization, where: o.ein == ^ein)
  end

  def get_or_create_organization(attrs \\ %{}) do
    case get_organization_by_ein(attrs[:ein]) do
      {:error, _reason} -> create_organization(attrs)
      {:ok, org} -> {:ok, org}
    end
  end

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{data: %Organization{}}

  """
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end

  @doc """
  Returns the list of awards.

  ## Examples

      iex> list_awards()
      [%Award{}, ...]

  """
  def list_awards(opts \\ []) do
    query = from a in Award, preload: [:recipient]
    query = add_state_filter(query, opts["state"])
    Repo.all(query)
  end

  defp add_state_filter(query, nil), do: query

  defp add_state_filter(query, state) do
    from a in query,
      join: o in Organization,
      on: o.id == a.recipient_id,
      where: o.state == ^state
  end

  @doc """
  Gets a single award.

  Raises `Ecto.NoResultsError` if the Award does not exist.

  ## Examples

      iex> get_award!(123)
      %Award{}

      iex> get_award!(456)
      ** (Ecto.NoResultsError)

  """
  def get_award!(id), do: Repo.get!(Award, id)

  @doc """
  Creates a award.

  ## Examples

      iex> create_award(%{field: value})
      {:ok, %Award{}}

      iex> create_award(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_award(attrs \\ %{}) do
    %Award{}
    |> Award.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a award.

  ## Examples

      iex> update_award(award, %{field: new_value})
      {:ok, %Award{}}

      iex> update_award(award, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_award(%Award{} = award, attrs) do
    award
    |> Award.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a award.

  ## Examples

      iex> delete_award(award)
      {:ok, %Award{}}

      iex> delete_award(award)
      {:error, %Ecto.Changeset{}}

  """
  def delete_award(%Award{} = award) do
    Repo.delete(award)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking award changes.

  ## Examples

      iex> change_award(award)
      %Ecto.Changeset{data: %Award{}}

  """
  def change_award(%Award{} = award, attrs \\ %{}) do
    Award.changeset(award, attrs)
  end

  @doc """
  Returns the list of filings.

  ## Examples

      iex> list_filings()
      [%Filing{}, ...]

  """
  def list_filings do
    query = from f in Filing, preload: [[awards: :recipient], :filer]
    Repo.all(query)
  end

  @doc """
  Gets a single filing.

  Raises `Ecto.NoResultsError` if the Filing does not exist.

  ## Examples

      iex> get_filing!(123)
      %Filing{}

      iex> get_filing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_filing!(id), do: Repo.get!(Filing, id)

  @doc """
  Creates a filing.

  ## Examples

      iex> create_filing(%{field: value})
      {:ok, %Filing{}}

      iex> create_filing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_filing(attrs \\ %{}) do
    %Filing{}
    |> Filing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a filing.

  ## Examples

      iex> update_filing(filing, %{field: new_value})
      {:ok, %Filing{}}

      iex> update_filing(filing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_filing(%Filing{} = filing, attrs) do
    filing
    |> Filing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a filing.

  ## Examples

      iex> delete_filing(filing)
      {:ok, %Filing{}}

      iex> delete_filing(filing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_filing(%Filing{} = filing) do
    Repo.delete(filing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking filing changes.

  ## Examples

      iex> change_filing(filing)
      %Ecto.Changeset{data: %Filing{}}

  """
  def change_filing(%Filing{} = filing, attrs \\ %{}) do
    Filing.changeset(filing, attrs)
  end
end

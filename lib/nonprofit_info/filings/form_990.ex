defmodule NonprofitInfo.Filings.Form990 do
  import SweetXml

  def parse_form_990(:xml, data) do
    filer =
      data
      |> xpath(~x"//Return/ReturnHeader/Filer")
      |> parse_filer()

    awards =
      data
      |> xpath(~x"//Return/ReturnData/IRS990ScheduleI/RecipientTable"l)
      |> Enum.map(&parse_award_data/1)

    %{
      filer: filer,
      awards: awards,
      tax_year:
        xpath(
          data,
          ~x"//Return/ReturnHeader/TaxYear/text() | //Return/ReturnHeader/TaxYr/text()"I
        )
    }
  end

  defp parse_award_data(award) do
    address =
      award
      |> xpath(~x"./AddressUS | ./USAddress")
      |> parse_address()

    name =
      award
      |> xpath(~x"./RecipientNameBusiness | ./RecipientBusinessName")
      |> xpath(~x"./BusinessNameLine1/text() | ./BusinessNameLine1Txt/text()"S)

    %{
      amount: xpath(award, ~x"./AmountOfCashGrant/text() | ./CashGrantAmt/text()"I),
      purpose: xpath(award, ~x"./PurposeOfGrant/text() | ./PurposeOfGrantTxt/text()"S),
      recipient:
        %{
          ein: xpath(award, ~x"./EINOfRecipient/text() | ./RecipientEIN/text()"S),
          name: name
        }
        |> Map.merge(address)
    }
  end

  defp parse_filer(filer) do
    address =
      filer
      |> xpath(~x"./USAddress")
      |> parse_address()

    name =
      filer
      |> xpath(~x"./BusinessName | ./Name")
      |> xpath(~x"./BusinessNameLine1/text() | ./BusinessNameLine1Txt/text()"S)

    %{
      ein: xpath(filer, ~x"./EIN/text()"S),
      name: name
    }
    |> Map.merge(address)
  end

  defp parse_address(address) do
    %{
      address1: xpath(address, ~x"./AddressLine1/text() | ./AddressLine1Txt/text()"S),
      address2: xpath(address, ~x"./AddressLine2/text() | ./AddressLine2Txt/text()"S),
      city: xpath(address, ~x"./City/text() | ./CityNm/text()"S),
      state: xpath(address, ~x"./State/text() | ./StateAbbreviationCd/text()"S),
      zip_code: xpath(address, ~x"./ZIPCode/text() | ./ZIPCd/text()"S)
    }
  end
end

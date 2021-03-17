defmodule NonprofitInfoWeb.PageLive do
  use NonprofitInfoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("process_form", %{"url" => url}, socket) do
    case NonprofitInfo.Filings.process_form_url(url) do
      {:ok, _filing} ->
        # {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}
        {:noreply,
         socket
         |> put_flash(:info, "Successfully processed form")
         |> assign(results: %{}, url: url)}

      {:error, reason} ->
        msg = reason |> format_errors() |> errors_to_string()

        {:noreply,
         socket
         |> put_flash(:error, "Error processing form: #{msg}")
         |> assign(results: %{}, url: url)}
    end
  end

  defp search(query) do
    if not NonprofitInfoWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end

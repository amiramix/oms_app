defmodule OmsApiWeb.ReadAPI do
  @moduledoc """
  A module responsible for reading from instances' APIs
  """

  # get_json and get_filename are utility functions to read the JSON from a file
  # In a proper app this wouldn't be needed as the 'get_latency'
  # function would read the JSON directly from the instance's API
  defp get_json(filename) do
    with {:ok, file_content} <- File.read(filename) do
      Poison.decode(file_content)
    end
  end

  defp get_filename(resolution) do
    "lib/oms_api_web/fixtures/fixture#{resolution}.json"
  end

  def get_latency(_instance, resolution) do
    cond do
      resolution === "24hrs" || resolution === "72hrs" ->
        get_json(get_filename(resolution))
      true ->
        {:error, :resolution}
    end
  end
end

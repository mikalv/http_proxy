defmodule HttpProxy.Utils.File.Test do
  use ExUnit.Case, async: true
  use Plug.Test

  alias HttpProxy.Utils.File, as: HttpProxyFile

  test "check path generations" do
    conn = conn(:get, "http://localhost:8080/")

    assert HttpProxyFile.get_export_path == "example"
    assert HttpProxyFile.get_export_path(conn) == "example/8080"
    assert HttpProxyFile.get_response_path == "test/data/__files"
    assert HttpProxyFile.get_mapping_path == "test/data/mappings"
  end

  test "check read json files" do
    json_test_dir = "test/data/mappings"
    json_file_path = ["test/data/mappings/sample.json", "test/data/mappings/sample2.json", "test/data/mappings/sample3.json"]
    expected_json = %{"request" => %{"path" => "request/path", "port" => 8080, "method" => "GET"},
              "response" => %{"body" => "<html>hello world</html>", "cookies" => %{},
                "headers" => %{"Content-Type" => "text/html; charset=UTF-8", "Server" => "GFE/2.0"}, "status_code" => 200}}

    assert {:ok, json_file_path} == HttpProxyFile.json_files(json_test_dir)
    assert {:ok, expected_json} == HttpProxyFile.read_json_file(List.first(json_file_path))
  end

  test "failed to read json files" do
    json_test_dir = "test/data/map"
    json_file_path = "test/data/mappings/sample"

    assert {:error, :enoent} == HttpProxyFile.json_files(json_test_dir)
    assert {:error, :enoent} == HttpProxyFile.read_json_file(json_file_path)
  end
end

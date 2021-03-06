class RiotApi::Lol_Status < RiotApi

  def self.get_shards_list args = []
    url = "#{base_lol_status_url}"
    get_api_response(url)
  end

  def self.get_shard_status args
    check_args args, [:region]
    url = "#{base_lol_status_url}/#{args[:region]}"
    get_api_response(url)
  end

  def self.base_lol_status_url
    "https://status.leagueoflegends.com/shards"
  end

  private_class_method :base_lol_status_url
end
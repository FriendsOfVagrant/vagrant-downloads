require 'excon'
require 'json'

class Tags
  # Returns a hash mapping of tag names to SHA commits for a given
  # GitHub repo.
  #
  # @param [String] repo
  # @return [Hash]
  def self.all(repo)
    response = Excon.get("https://api.github.com/repos/#{repo}/git/refs")
    data = JSON.parse(response.body)

    # Find all the tag objects and put them in the dictionary where their
    # value is the SHA of the commit they point to.
    results = {}
    data.each do |object|
      if object["ref"] =~ /^refs\/tags\/(.+?)$/
        results[$1.to_s] = object["object"]["sha"]
      end
    end

    results
  end
end

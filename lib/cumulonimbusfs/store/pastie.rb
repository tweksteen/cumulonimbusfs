require 'turf'
require 'base64'
require 'fusefs'
require 'lru_redux'

require_relative '../textkvs'

module CumulonimbusFS

  class PastieKeyValueStore < TextKeyValueStore

    @@form = {"utf8" => "✓",
            "paste[authorization]" => "burger",
            "paste[access_key]" => "",
            "paste[parser_id]" => 6,
            "paste[restricted]" => 1,
            "commit" => "Create Paste"
    }

    def initialize
      @cache = LruRedux::Cache.new(100)
    end

    ##
    # Store a value, returns the associated key
    #
    def store(value)
      f = @@form.clone
      f["paste[body]"] = Base64.encode64(value)
      r = Turf::multipart("http://pastie.org/pastes", f)
      r.run
      pastie = r.response.cookies["pasties"]
      key = r.response["Location"].first.split("/").last
      puts "@store #{pastie}_#{key}"
      pastie + "_" + key
    end

    ##
    # Retrieve the value for a key
    #
    def retrieve(name)
      @cache.getset(name){
        puts "@retrieve #{name}"
        pastie, key = name.split("_", 2)
        r = Turf::get("http://pastie.org/pastes/#{pastie}/download?key=#{key}")
        r.run
        #puts "Got:", "="*80, r.response.content, "="*80
        Base64.decode64(r.response.content)
      }
    end

    def create_root
      puts "@create_root"
      store(gen_directory({}))
    end
  end

end

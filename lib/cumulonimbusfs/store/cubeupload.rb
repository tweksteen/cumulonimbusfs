require 'turf'
require 'fusefs'
require 'lru_redux'
require 'json'

require_relative '../imagekvs'

module CumulonimbusFS 
  class CubeUpload < ImageKeyValueStore

    @@form = { "name" => "title.png",
            "userHash" => "false",
            "userID" => "false"
    }

    def initialize
      @cache = LruRedux::Cache.new(100)
    end

    ##
    # Store a value, returns the associated key
    #
    def store(value)
      f = @@form.clone
      f["fileinput[0]"] = {content: value, filename: "title.png", type: "image/png"}
      r = Turf::multipart("http://cubeupload.com/upload_json.php", f)
      puts r
      r.run
      puts r.response
      key = JSON.parse(r.response.content)['file_name']
      puts "@store #{key}"
      key
    end

    ##
    # Retrieve the value for a key
    #
    def retrieve(name)
      @cache.getset(name){
        puts "@retrieve #{name}"
        r = Turf::get("http://i.cubeupload.com/#{name}")
        r.run
        puts r.response
        #puts "Got:", "="*80, r.response.content, "="*80
        r.response.content
      }
    end

    def create_root
      puts "@create_root"
      store(gen_directory({}))
    end
    
  end

end



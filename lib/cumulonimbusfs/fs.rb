require 'fusefs'

module CumulonimbusFS

  class CumulonimbusFS < FuseFS::FuseDir
    def initialize(store, origin)
      @store = store
      @origin = origin.nil? ? @store.create_root : origin
      puts "Using #{@store.class} from #{@origin}"
    end

    def contents(path)
      puts "@contents #{path}"
      dkey = get_key(path)
      d = @store.parse_directory(@store.retrieve dkey)
      d.keys
    end

    def directory?(path)
      puts "@directory? #{path}"
      d = get_parent(path)
      basename = scan_path(path).last
      d.has_key?(basename) and d[basename][:type] == "D"
    end

    def file?(path)
      puts "@file? #{path}"
      d = get_parent(path)
      basename = scan_path(path).last
      d.has_key?(basename) and d[basename][:type] == "F"
    end

    def executable?(path)
      puts "@executable?"
      false
    end

    def size(path)
      puts "@size"
      read_file(path).length
    end

    def read_file(path)
      puts "@read_file #{path}"
      k = get_key(path)
      @store.parse_file(@store.retrieve k)
    end

    def can_write?(path)
      puts "@can_write? #{path}"
      true
    end

    def can_delete?(path)
      puts "@can_delete? #{path}"
      file? path
    end

    def write_to(path, content)
      puts "@write_to #{path}"
      key = @store.store(@store.gen_file content)
      update_parent(path) { |p, basename|
        p[basename] = { key: key, type: "F" }
        next p
      }
    end

    def delete(path)
      puts "@delete #{path}"
      update_parent(path) { |p, basename|
        p.delete(basename)
        next p
      }
    end

    def can_mkdir?(path)
      puts "@can_mkdir? #{path}"
      true
    end

    def mkdir(path)
      puts "@mkdir #{path}"
      dkey = @store.store(@store.gen_directory({}))
      update_parent(path) { |p, basename|
        p[basename] =  { key:dkey, type: "D" }
        next p
      }
    end

    def can_rmdir?(path)
      puts "@can_rmdir? #{path}"
      true
    end

    def rmdir(path)
      puts "@rmdir #{path}"
      update_parent(path) { |p, basename|
        p.delete(basename)
        next p
      }
    end

    private

    def get_key(path)
      return @origin if path == "/"
      d = get_parent(path)
      d[scan_path(path).last][:key]
    end

    def get_parent(path)
      puts "@get_parent #{path}"
      current = @origin
      d = @store.parse_directory(@store.retrieve current)
      for p in scan_path(path)[0..-2]
        current = d[p][:key]
        d = @store.parse_directory(@store.retrieve current)
      end
      d
    end

    def update_parent(path, &block)
      p = get_parent(path)
      basename = scan_path(path).last
      dirname = "/" + scan_path(path)[0..-2].join("/")
      p = block.call(p, basename)
      dkey = @store.store(@store.gen_directory(p))
      if dirname == "/"
        @origin = dkey
        puts "New origin: #{dkey}"
      else
        puts "Updating: #{dirname}"
        update_parent(dirname){ |p, basename|
          p[basename] = { key: dkey, type: "D" }
          next p
        }
      end
    end

  end

end

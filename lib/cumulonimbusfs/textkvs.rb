require 'base64'

module CumulonimbusFS

  class TextKeyValueStore

    def parse_directory(content)
      content = Base64.decode64(content)
      #puts "Parsing directory", content
      if content.lines.first != "#D\n"
        puts "NOT A DIRECTORY"
      end
      Hash[ content.lines[1..-1].collect { |l|
        t, k, n = l.split(" ")
        [n, {key: k,type: t}]
      }]
    end

    def gen_directory(files)
      header = "#D\n"
      content = files.each.collect { |n, w|
        "#{w[:type]} #{w[:key]} #{n}"
      }.join("\n")
      Base64.encode64(header + content)
    end

    def parse_file(content)
      content = Base64.decode64(content)
      #puts "Parsing file", content
      if content.lines.first != "#F\n"
        puts "NOT A FILE"
      end
      content.split("\n", 2).last
    end

    def gen_file(content)
      Base64.encode64("#F\n" + content)
    end

  end

end

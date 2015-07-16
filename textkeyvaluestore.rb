class TextKeyValueStore

  def parse_directory(content)
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
    header + content
  end

  def parse_file(content)
    #puts "Parsing file", content
    if content.lines.first != "#F\n"
      puts "NOT A FILE"
    end
    content.split("\n", 2).last
  end

  def gen_file(content)
    "#F\n" + content
  end

end

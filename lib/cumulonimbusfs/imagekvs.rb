require 'chunky_png'

require_relative 'textkvs'

module CumulonimbusFS
  class ImageKeyValueStore < TextKeyValueStore

    def parse_directory(content)
      content = png_to_bytes content
      super content
    end

    def gen_directory(files)
      content = super files
      bytes_to_png content
    end

    def parse_file(content)
      content = png_to_bytes content
      super content
    end

    def gen_file(content)
      content = super content
      bytes_to_png content
    end

    private

    def pad_content(c, l)
      c + "\n" * (l - c.length % l)
    end

    def bytes_to_png(bytes)
      size = bytes.bytesize
      width = Math.sqrt((size.to_f / 4) + 1).ceil
      #puts "size=#{size} width=#{width}"
      bytes = pad_content([size].pack("l>") + bytes, 4)
      png = ChunkyPNG::Image.new(width, width, ChunkyPNG::Color::TRANSPARENT)
      bytes.chars.each_slice(4).each_with_index { |item, i|
        r, c = i / width, i % width
        p = item.join("").unpack("l>").first
        #puts "r=#{r} c=#{c} p=#{p} item=#{item}"
        png[r,c] = p
      }
      png.to_blob
    end

    def png_to_bytes(blob)
      png = ChunkyPNG::Image.from_blob(blob)
      width = png.dimension.width
      size = png[0,0]
      #puts "size=#{size} width=#{width}"
      content = ""
      (1..(size.to_f/4).ceil).each { |i|
        r, c = i / width, i % width
        #puts "r=#{r} c=#{c} i=#{i}"
        content << [png[r,c]].pack("l>")
      }
      content
    end

  end

end

#ikvs = ImageKeyValueStore.new
#puts ikvs.gen_file("test1234")
#x = ikvs.gen_file("asdf9wegxc7vbze3ghw5hn"* Random.rand(4096) + "a")
#puts x
#puts ikvs.parse_file(x)

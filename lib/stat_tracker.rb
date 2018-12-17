CSV.foreach(@file_path, {headers: true, header_converters: :symbol}) do |row|
      binding.pry
      @cards << Card.new(row[:question], row[:answer], row[:category].to_sym)
    end

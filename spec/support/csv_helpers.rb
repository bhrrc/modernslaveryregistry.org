def enumerator_csv_to_string(enum)
  str = ""

  enum.each do |e|
    str += e.to_s
  end

  str
end
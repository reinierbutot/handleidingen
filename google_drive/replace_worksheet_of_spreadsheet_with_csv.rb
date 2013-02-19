require 'csv'
require "google_drive"
# google_drive gem op github: https://github.com/gimite/google-drive-ruby
# google_drive gem docs: http://gimite.net/doc/google-drive-ruby/

gdoc = { "login" => "je email",
		 "password" => "je wachtwoord",
		 "spreadsheet_key" => "key van de spreadsheet uit de url",
		 "file" => "pad naar het csv bestand op je hardeschijf",
		 "worksheet_title" => "de naam van het tabblad"
}

puts "... Connecting to Google docs"

session = GoogleDrive.login(gdoc['login'], gdoc['password'])

puts "... Downloading worksheet from Google docs"

ws = session.spreadsheet_by_key(gdoc['spreadsheet_key']).worksheet_by_title(gdoc['worksheet_title'])

puts "... Reading and Processing CSV"

rows_in_csv = 0
cols_in_csv = 0
old_number_of_rows = ws.num_rows
old_number_of_cols = ws.num_cols
did_once = false

CSV.foreach(gdoc['file']) do |row|
  row.each_with_index do |row_item,index_item|
    ws[rows_in_csv+1,index_item+1] = row_item
  end
  
  if did_once == false
  	cols_in_csv = row.length
  	did_once = true
  end

  rows_in_csv+=1
end

puts "... Deleting obsolete data, if present"

#rows
if old_number_of_rows > rows_in_csv
  for row in rows_in_csv+1..old_number_of_rows
    for col in 1..old_number_of_cols
      ws[row, col] = nil
    end
  end
end
#cols
if old_number_of_cols > cols_in_csv
  for row in 1..old_number_of_rows
    for col in cols_in_csv+1..old_number_of_cols
      ws[row, col] = nil
    end
  end
end

puts "... Uploading"

ws.save

puts "... Done!"
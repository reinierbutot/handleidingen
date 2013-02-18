# google_drive gem op github: https://github.com/gimite/google-drive-ruby
# google_drive gem docs: http://gimite.net/doc/google-drive-ruby/

require 'csv'
require "google_drive"
# voor veiligheid: nieuwe anonieme gebruiker aanmaken + uitnodigen voor bewerken van spreadsheet
session = GoogleDrive.login("het email adres van anon gebruiker", "een wachtwoord")

#session.upload_from_file("/path/to/hello.txt", "hello.txt", :convert => treu)

# de key is in de url van google drive document te vinden
ws = session.spreadsheet_by_key("key van het spreadsheet").worksheets[0]

# Changes content of cells.
#ws[2, 1] = "foo"
#ws[2, 2] = "bar"
#ws.save()

# Reloads the worksheet to get changes by other clients.
#ws.reload()

#arr_of_arrs = CSV.read("/users/reinier/desktop/test.csv")

# zet csv waarden uit bestand om naar format bruikbaar voor worksheet
worksheetformat = Array.new
CSV.foreach("/users/reinier/desktop/test.csv") do |row|
  worksheetformat << row
end

for row in 1..ws.num_rows
  for col in 1..ws.num_cols
    ws[row, col] = worksheetformat[row-1][col-1]
  end
end

# Dump all cells
p ws.rows

#ws.save()
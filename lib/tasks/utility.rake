require 'csv'
namespace :utility do
  desc "Transform to NAACCR"
  task(transform_to_naaccr: :environment) do  |t, args|
    transform = ''
    columns = CSV.new(File.open('lib/setup/data/naaccr_version_13xx_record_layout.txt'), headers: true, col_sep: "\t", return_headers: false)
    columns.each do |column|
      column = column.to_hash
      transform << "field :#{columnize(column["Item Name"])}, #{column["Length"]}, '#{column["Column #"]}', :alphanumeric \n"
    end
    puts transform

    transform = ''
    columns = CSV.new(File.open('lib/setup/data/naaccr_version_13xx_record_layout.txt'), headers: true, col_sep: "\t", return_headers: false)
    columns.each do |column|
      column = column.to_hash
      transform << "field_value :#{columnize(column["Item Name"])}, #{column["Length"]}, '' \n"
    end
    puts transform
  end
end

def columnize(column)
  column.downcase!
  column.gsub!(' ','_')
  column.gsub!('-','_')
  column.gsub!('/','_')
  column.gsub!('--','_')
  column.gsub!('__','_')
  column.gsub!('(','_')
  column.gsub!(')','_')
  column.gsub!(',','_')
  column.gsub!('&','_')
  column
end
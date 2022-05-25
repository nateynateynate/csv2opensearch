#!/usr/bin/ruby

require 'csv'
require 'json'
require 'opensearch'



# I could have done more. 
# Not the greatest ruby code. 
# Must stop repeating.



# This just happens to be the index mapping I want to use. Replace this with your mapping. 
# TODO: Make it take a mapping via a json file. 
indexMapping = {
  'mappings': {
    'properties': {
      'created_at': { "type": "date",
                      "format": "yyyy-MM-dd HH:mm:ss zzz" },
      'tag': { "type": "keyword" },
      'category_id': { "type": "keyword" },
      'title': { "type": "keyword" }
    }
  }
} 

def usage
  puts "Usage: #{__FILE__} <index_name> <input_csv_file>"
  exit
end

def createIndex(name, mapping)
  puts "Creating index #{name}."
  client = OpenSearch::Client.new( host: 'https://admin:admin@localhost:9200/', transport_options: { ssl: { verify: false } })
  client.indices.create(
    index: name,
    body: mapping
  )
end

def indexExists(indexName)
  client = OpenSearch::Client.new( host: 'https://admin:admin@localhost:9200/', transport_options: { ssl: { verify: false } })
  client.indices.exists(
    index: indexName,
  )
end
  

def indexData(fileName, index)

  csvFile = File.open(fileName, "r")
  csvData = csvFile.read()


  csv = CSV.new(csvData, :headers => true, :header_converters => :symbol, :converters => :all)
  csvData = csv.to_a.map {|row| row.to_hash }

  client = OpenSearch::Client.new( host: 'https://admin:admin@localhost:9200/', transport_options: { ssl: { verify: false } })
  csvData.each do |csvRow|
    response = client.index(
         index: index,
             body: csvRow,
                 refresh: true
    )

    puts response
  end
end



usage if ARGV.length < 2
indexName = ARGV[0]
createIndex(indexName, indexMapping) unless indexExists(indexName)
fileName = ARGV[1]
indexData(fileName, indexName)

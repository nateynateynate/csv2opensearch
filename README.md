# csv2opensearch

I wrote something simple but useful and I'd like to share it! Take a csv with header lines and ingest it.

It assumes that the OpenSearch API is available on `localhost:9200` 






## Usage

Set the environment variables `OS_USER` and `OS_PASSWORD` lest they both default to `admin`

`csv2opensearch.rb <index_name> <csv_filename>`

Have fun! 

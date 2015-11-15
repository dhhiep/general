#!/usr/bin/ruby

REMOTE_IP_ADDRESS = "192.168.0.111"
LOCAL_IP_ADDRESS = "localhost"
LOCAL_DB_USER = "postgres"
LOCAL_DB_PASS = "postgres"
REMOTE_DB_USER = "postgres"
REMOTE_DB_PASS = "postgres"

database_names = 
  %w(
      db_1_development
      db_2_development
      db_3_development
      db_4_development
      db_5_development
    )

# DROP DATABASE (comment out if unnecessary)
database_names.each do |db_name|
  %x{ PGPASSWORD=#{LOCAL_DB_PASS} dropdb -U #{LOCAL_DB_USER} -h #{LOCAL_IP_ADDRESS} #{db_name} }
end

database_names.each do |db_name|
  puts "Processing: #{db_name}"
  
  # CREATE DATABASE
  %x{ PGPASSWORD=#{LOCAL_DB_PASS} createdb -U #{LOCAL_DB_USER} -h #{LOCAL_IP_ADDRESS} #{db_name} }

  # TRANFER DATA FROM REMOTE DATABASE TO LOCAL
  %x{ PGPASSWORD=#{REMOTE_DB_PASS} pg_dump -C -h #{REMOTE_IP_ADDRESS} -U #{REMOTE_DB_USER} #{db_name} | PGPASSWORD=#{LOCAL_DB_PASS} psql -h #{LOCAL_IP_ADDRESS} -U #{REMOTE_DB_USER} #{db_name} }

  puts "Processed: #{db_name}"
end

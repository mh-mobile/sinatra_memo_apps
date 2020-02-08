# frozen_string_literal: true

require "faker"

task default: :json_data

Faker::Config.locale = :ja

desc "generate json data"
task :json_data do
  File.open("resource/memo.json", "w") do |file|
    json = []
    100.times do |i|
      json << {
        "memo_id": i + 1,
        "content": "#{Faker::Lorem.paragraph(sentence_count: 20)}",
        "created_at": Time.now.iso8601,
        "updated_at": Time.now.iso8601
      }
    end

    JSON.dump(json, file)
  end
end

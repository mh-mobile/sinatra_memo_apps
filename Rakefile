require "faker"
require "set"

task default: :json_data

Faker::Config::locale = :ja

desc "generate json data"
task :json_data do
  File.open('resource/memo.json', 'w') do |file|
    json = []
    100.times do |i|
      json << {
        "memo_id": i + 1,
        "content": "#{Faker::Lorem.paragraph(sentence_count: 20)}"
      }
    end

    JSON.dump(json, file)
  end
end

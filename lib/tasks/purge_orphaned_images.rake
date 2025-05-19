namespace :active_storage do
  desc "Delete routines whose attached image file is missing"
  task purge_orphaned_routines: :environment do
    puts "Checking routines for missing images..."

    deleted = 0

    Routine.all.each do |routine|
      next unless routine.image.attached?

      begin
        routine.image.blob.open {} # ファイルがあれば何もしない
      rescue StandardError
        puts "Deleting routine_id=#{routine.id}（画像ファイルなし）"
        routine.destroy
        deleted += 1
      end
    end

    puts "削除完了：#{deleted}件"
  end
end
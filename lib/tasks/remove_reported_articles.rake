namespace :articles do
  desc "Remove articles reported 6 or more times"
  task remove_reported: :environment do
    Article.where('reports_count >= ?', 6).find_each do |article|
      puts "Removing Article ID: #{article.id}, Title: #{article.title}, Reports Count: #{article.reports_count}"
      article.destroy
    end
  end
end

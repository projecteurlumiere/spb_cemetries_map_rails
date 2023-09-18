desc "Re-creates and re-seeds db from scratch"

namespace :db do
  task :recreate do
    sh "rails db:drop; rails db:create; rails db:migrate; rails db:seed"
  end
end

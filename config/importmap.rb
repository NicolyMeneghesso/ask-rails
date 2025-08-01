# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "panel/questions", to: "panel/questions.js"
pin "panel/answers", to: "panel/answers.js"
pin "panel/home/card_users", to: "panel/home/card_users.js"
pin "panel/home/card_subjects", to: "panel/home/card_subjects.js"
pin "panel/home/card_user_answers", to: "panel/home/card_user_answers.js"
pin "panel/home/card_user_progress", to: "panel/home/card_user_progress.js"
pin "panel/zip_code", to: "panel/zip_code.js"

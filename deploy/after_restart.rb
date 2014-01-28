run "cd #{release_path} && bundle exec rake deploy:notify TO=#{@configuration[:environment]} REVISION=#{@configuration[:revision]}"
run "cd #{release_path} && sudo monit -g dj_ohheyworld restart all"
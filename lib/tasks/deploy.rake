namespace :deploy do
  desc "notify developers of deployment"
  task :notify => :environment do
    attribs = {}
    ARGV.each do |arg|
      if arg.match(/TO=(.*)/)
        attribs[:env_name] = $1
      elsif arg.match(/REVISION=(.*)/)
        attribs[:revision] = $1
      end
    end
    SupportMailer.deploy_notification(attribs).deliver
  end
end
class SupportMailer < ActionMailer::Base
  default :from => "support@ohheyworld.com"
  
  def deploy_notification(attribs)
    @env_name = attribs[:env_name]
    @revision = attribs[:revision]
    mail(to: "eric.roland@gmail.com", cc: ["drew@ohheyworld.com","moyer.will@gmail.com"], subject: "A build of ohheyworld was deployed to #{attribs[:env_name]}")
  end
end
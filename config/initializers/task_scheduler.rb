scheduler = Rufus::Scheduler.start_new

scheduler.every("1m") do
  MailRetriever.get_mail
end
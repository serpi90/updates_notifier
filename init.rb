
require 'redmine'

Rails.logger.info 'Starting Updates Notifier plugin...'

require_dependency 'updates_notifier_issue_change_listener'

Redmine::Plugin.register :updates_notifier do
  name 'Updates Notifier plugin'
  author 'Julian Maestri'
  description 'This sends update notifications to a callback URL when changes are made within Redmine.'
  version '0.0.2'
  url 'https://github.com/serpi90/updates_notifier'
  author_url 'https://github.com/serpi90/updates_notifier'

  settings :default => {'callback_url' => 'http://example.com/callback/' }, :partial => 'settings/updates_notifier'
end

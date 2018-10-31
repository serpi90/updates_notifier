require 'rubygems'
require 'httpclient'
require 'json'

class UpdatesNotifier < ActiveRecord::Base
  def self.send_issue_update(user, issueId, journal)
    changes = []
    journal.details.each do |j|
      changes.push({
        "property" => j.prop_key,
        "value" => j.value
      })
    end
    u = {"email" => user.mail, "firstname" => user.firstname, "lastname" => user.lastname}
    post_to_server({
        "type" => "issue",
        "user" => u.to_json,
        "issue" => issueId,
        "comment" => journal.notes,
        "changes" => changes.to_json,
    })
  end
private
  def self.callback_url()
    return Setting.plugin_updates_notifier['callback_url']
  end
  def self.post_to_server(data)
    client = HTTPClient.new
    client.debug_dev = STDOUT if $DEBUG
    Rails.logger.debug("UPDATES_NOTIFIER: Posting update back to #{self.callback_url} : #{data.to_json}")
    response = client.post(self.callback_url, data)
    if response.status_code >= 400
      Rails.logger.warn("UPDATES_NOTIFIER: Response code from #{self.callback_url}: #{response.status_code.to_s}")
    else
      Rails.logger.debug("UPDATES_NOTIFIER: Response code from #{self.callback_url}: #{response.status_code.to_s}")
    end
    return response
  end
end

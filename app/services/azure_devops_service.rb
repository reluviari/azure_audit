require 'faraday'
require 'json'

class AzureDevopsService
  def self.get_logs(start_date, end_date)
    organization_url = ENV['AZURE_DEVOPS_ORG']
    personal_access_token = ENV['AZURE_DEVOPS_PAT']

    api_url = "#{organization_url}/_apis/audit/auditlog"

    params = {
      startTime: start_date.iso8601,
      endTime: end_date.iso8601,
      'api-version': '7.1-preview.1'
    }

    conn = Faraday.new(url: api_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.headers['Authorization'] = "Basic #{personal_access_token}"
    end

    response = conn.get do |req|
      req.params = params
    end

    if response.status == 200
      JSON.parse(response.body)['auditLogEntries']
    else
      puts "Erro ao obter logs: #{response.status} - #{response.body}"
      []
    end
  end
end
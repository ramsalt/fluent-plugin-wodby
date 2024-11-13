#
# Copyright 2022-2024: Ramsalt Lab
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/filter"
require "rest-client"
require "json"

module Fluent
  module Plugin
    class WodbyFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter("wodby", self)

      config_param :api_key, :string, secret: true

      def start
        super

        @instance_map = {}
        log.info "Initialized wodby plugin"
      end

      def filter(tag, time, record)
        record['wodby']['filter'] = true

        if record.has_key?('kubernetes') && record['kubernetes'].has_key?('namespace_name')
          namespace = record['kubernetes']['namespace_name']
          unless @instance_map.has_key?(namespace)
            record['wodby']['instance_query'] = namespace
            instance = get_instance(namespace)
            app = get_app(instance['app_id'])
            org = get_org(app['org_id'])

            @instance_map[namespace] = {
              'name' => "#{app['name']}.#{instance['name']}",
              'title' => "#{app['title']} - #{instance['title']}",
              'type' => instance['type'],
              'organization' => org['name'],
              'organization_title' => org['title'],
            }
          end

          record['wodby']['instance'] = @instance_map[namespace]['name']
          record['wodby']['instance_title'] = @instance_map[namespace]['title']
          record['wodby']['instance_type'] = @instance_map[namespace]['type']
          record['wodby']['organization'] = @instance_map[namespace]['organization']
          record['wodby']['organization_title'] = @instance_map[namespace]['organization_title']
        else
          log.info "No namespace found"
          log.info record
        end

        record
      end

      private

      def get_instance(instance_id)
        begin
          response = RestClient.get(
            "https://api.wodby.com/api/v3/instances/#{instance_id}",
            headers={'X-API-KEY': @api_key}
          )
          instance = JSON.parse(response)
        rescue RestClient::ExceptionWithResponse
          instance = {}
        end

        instance
      end

      def get_app(app_id)
        begin
          response = RestClient.get(
            "https://api.wodby.com/api/v3/apps/#{app_id}",
            headers={'X-API-KEY': @api_key}
          )
          app = JSON.parse(response)
        rescue RestClient::ExceptionWithResponse
          app = {}
        end

        app
      end

      def get_org(org_id)
        begin
          response = RestClient.get(
            "https://api.wodby.com/api/v3/orgs/#{org_id}",
            headers={'X-API-KEY': @api_key}
          )
          org = JSON.parse(response)
        rescue RestClient::ExceptionWithResponse
          org = {}
        end

        org
      end
    end
  end
end

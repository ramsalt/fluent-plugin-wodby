#
# Copyright 2022- TODO: Write your name
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

      def filter(tag, time, record)
        if record.has_key?('kubernetes.namespace_name')
          instance = get_instance(record['kubernetes.namespace_name'])
          app = get_app(instance['app_id'])

          record['wodby.instance'] = "#{app['title']}-#{instance['name']}"
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
        rescue RestClient::ExceptionWithResponse => e
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
        rescue RestClient::ExceptionWithResponse => e
          app = {}
        end

        app
      end
    end
  end
end

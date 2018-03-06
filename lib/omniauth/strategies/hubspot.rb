require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class HubSpot < OmniAuth::Strategies::OAuth2
      option :name, 'hubspot'

      args %i[client_id client_secret]

      option :client_options,
             site: 'https://api.hubapi.com',
             authorize_url: 'https://app.hubspot.com/oauth/authorize',
             token_url: 'oauth/v1/token'

      private

      def build_access_token
        verifier = request.params['code']
        client.auth_code.get_token(verifier,
                                   { redirect_uri: callback_url_without_code }
                                     .merge(token_params.to_hash(symbolize_keys: true)),
                                   deep_symbolize(options.auth_token_params))
      end

      def callback_url_without_code
        callback_url.split('?').first
      end
    end
  end
end

OmniAuth.config.add_camelization 'hubspot', 'HubSpot'

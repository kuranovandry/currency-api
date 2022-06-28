class RateSerializer
  include JSONAPI::Serializer

  attributes :code, :currency_name, :average, :date

  cache_options store: Rails.cache, namespace: 'rate-serializer', expires_in: 1.hour
end

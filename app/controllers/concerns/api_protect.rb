module ApiProtect
  extend ActiveSupport::Concern

  private

  def check_ip_address
    return if Rails.env.development?

    key = "#{request.remote_ip}-request-count"
    request_count = $redis.get(key)
    return $redis.set(key, 1, ex: 10.minutes) if request_count.nil?

    if request_count.to_i > 1000
      return render json:   { status: 429, message: t('.too_many_requests') },
                    status: :too_many_requests
    end
    $redis.incr(key)
  end
end

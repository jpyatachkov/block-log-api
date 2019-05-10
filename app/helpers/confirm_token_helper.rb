module ConfirmTokenHelper
  @@EMAIL_NAMESPACE = "EMAIL_TOKEN"
  @@TOKEN_EXPIRES = ENV['CONFIRM_TOKEN_LIFETIME'].to_i

  Tuple = Struct.new(:is_error, :data)

  def generate_token(user_id, logger)
    token = SecureRandom.urlsafe_base64.to_s
    $redis.set("#{@@EMAIL_NAMESPACE}:#{token}", user_id, ex: @@TOKEN_EXPIRES)
    token
  rescue StandardError => e
    logger.error(e)
    nil
  end

  def reset_token(user_id, logger)
    p @@TOKEN_EXPIRES
    generate_token user_id, logger
  end

  def find_user_by_token(token, logger)
    user_id = $redis.get("#{@@EMAIL_NAMESPACE}:#{token}")
    $redis.del("#{@@EMAIL_NAMESPACE}:#{token}")
    Tuple.new(false, user_id)
  rescue StandardError => e
    logger.error(e)
    Tuple.new(true, nil)
  end
end

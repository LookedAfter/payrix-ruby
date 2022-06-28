# frozen_string_literal: true

require 'faraday/error'
module Payrix
  class Error < Faraday::Error
  end

  class Payrix::BadRequestError < Error
  end

  class Payrix::UnauthorizedError < Error
  end

  class Payrix::ForbiddenError  < Error
  end

  class Payrix::ResourceNotFound  < Error
  end

  class Payrix::ProxyAuthError  < Error
  end

  class Payrix::ConflictError < Error
  end

  class Payrix::UnprocessableEntityError  < Error
  end

  class Payrix::ClientError < Error
  end

  class Payrix::ServerError < Error
  end

  class Payrix::NilStatusError  < Error
  end

  class InvalidResponseError < Error
  end
end


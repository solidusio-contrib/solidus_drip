# frozen_string_literal: true

require 'drip'

require 'solidus_drip/configuration'
require 'solidus_drip/version'
require 'solidus_drip/engine'

require 'solidus_drip/base'
require 'solidus_drip/shopper_activity'
require 'solidus_drip/shopper_activity/order'
require 'solidus_drip/shopper_activity/product'


module SolidusDrip
  def self.use_events?
    Gem::Requirement.new('>= 2.11').satisfied_by?(::Spree.solidus_gem_version)
  end
end

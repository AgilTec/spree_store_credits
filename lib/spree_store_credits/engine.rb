module SpreeStoreCredits
  class Engine < Rails::Engine
    isolate_namespace Spree
    engine_name 'spree_store_credits'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'spree_store_credits.register.promotion.actions', :after => 'spree.promo.register.promotions.actions' do |app|
      app.config.spree.promotions.actions <<  Spree::Promotion::Actions::GiveStoreCredit
      app.config.spree.promotions.actions <<  Spree::Promotion::Actions::GiveStoreCreditAsPercentage
    end

    config.to_prepare &method(:activate).to_proc
    config.autoload_paths += %W(#{config.root}/lib)

  end
end
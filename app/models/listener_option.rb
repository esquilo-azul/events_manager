class ListenerOption < ActiveRecord::Base
  DEFAULT_DELAY = 0

  class << self
    def listener_class_list
      @listener_classes ||= ::EventsManager.all_listeners
    end

    def listener_class_options
      listener_class_list.sort.map { |v| [v, v] }
    end

    def listener_delay(listener_class)
      o = ::ListenerOption.where(listener_class: listener_class).first
      o && o.delay.present? && o.delay >= 0 ? o.delay : DEFAULT_DELAY
    end
  end

  validates :listener_class, presence: true, uniqueness: true,
                             inclusion: { in: listener_class_list }
  validates :delay, allow_blank: true,
                    numericality: { integer_only: true }
end

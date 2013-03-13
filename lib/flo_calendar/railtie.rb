module FloCalendar
  class Railtie < Rails::Railtie
    initializer "flo_calendar.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end

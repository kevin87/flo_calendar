module FloCalendar
  module ViewHelpers
    def flo_calendar(events, options={}, &block)
      raise 'SimpleCalendar requires a block to be passed in' unless block_given?


      opts = {
          :year       => (params[:year] || Time.zone.now.year).to_i,
          :month      => 1,
          :start_day  => :sunday,
          :class      => "table table-bordered table-striped calendar",

      }
      options.reverse_merge! opts
      events       ||= []
      selected_month = Date.new(options[:year], options[:month])
      current_date = Date.today
      calendar_view = []
      12.times do
        range = build_total_range selected_month, options
        month_array = range.each_slice(7).to_a
        calendar_view << flo_draw_calendar(selected_month, month_array, current_date, events, options, block)
        selected_month = selected_month.next_month()
      end
      calendar_view.join.html_safe
    end

    private

    def flo_draw_calendar(selected_month, month, current_date, events, options, block)
      tags = []
      today = Date.today
      tags << content_tag(:table) do
        tags << draw_month_header(selected_month, options)
        day_names = I18n.t("date.abbr_day_names")
        day_names = day_names.rotate((Date::DAYS_INTO_WEEK[options[:start_day]] + 1) % 7)
        content_tag(:body) do
          month.collect do |week|
            content_tag(:tr, :class => (week.include?(Date.today) ? "current-week week" : "week")) do
              week.collect do |date|
                td_class = ["day"]
                td_class << "today" if today == date
                td_class << "not-current-month" if selected_month.month != date.month
                td_class << "past" if today > date
                td_class << "future" if today < date
                td_class << "wday-#{date.wday.to_s}" # <- to enable different styles for weekend, etc

                cur_events = draw_day_events(date, events)

                td_class << (cur_events.any? ? "events" : "no-events")

                content_tag(:td, :class => td_class.join(" "), :'data-date-iso'=>date.to_s, 'data-date'=>date.to_s.gsub('-', '/')) do
                  content_tag(:div) do
                    divs = []
                    concat content_tag(:div, date.day.to_s, :class=>"day_number")

                    if cur_events.empty? && options[:empty_date]
                      concat options[:empty_date].call(date)
                    else
                      divs << cur_events.collect{ |event| block.call(event) }
                    end

                    divs.join.html_safe
                  end #content_tag :div
                end #content_tag :td

              end.join.html_safe
            end #content_tag :tr
          end.join.html_safe
        end
      end
      tags.join.html_safe
    end

    def build_total_range(selected_month, options)
      start_date = selected_month.beginning_of_month.beginning_of_week(options[:start_day])
      end_date   = selected_month.end_of_month.end_of_week(options[:start_day])

      (start_date..end_date).to_a
    end

    # Returns an array of events for a given day
    def draw_day_events(date, events)
      events.select { |e| e.start_time.to_date == date }
    end

    # Generates the header that includes the month and next and previous months
    def draw_month_header(selected_month, options)
      content_tag :h2 do
        tags = []

        tags << "#{I18n.t("date.month_names")[selected_month.month]} #{selected_month.year}"

        tags.join.html_safe
      end
    end
  end
end

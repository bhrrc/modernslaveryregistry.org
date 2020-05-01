Time::DATE_FORMATS[:human_ordinal] = lambda { |time| time.strftime("#{time.day.ordinalize} %B %Y")}

module ApplicationHelper
  NAVIGATION_ITEMS = [
    { label: "Dashboard", path: :root_path, controller: "home", icon: "dashboard" },
    { label: "Students", path: :students_path, controller: "students", icon: "students" },
    { label: "Courses", path: :courses_path, controller: "courses", icon: "courses" },
    { label: "Units", path: :units_path, controller: "units", icon: "units" },
    { label: "Enrolments", path: :enrolments_path, controller: "enrolments", icon: "enrolments" },
    { label: "Results", path: :results_path, controller: "results", icon: "results" }
  ].freeze

  def navigation_items
    NAVIGATION_ITEMS.map do |item|
      [ item[:label], public_send(item[:path]), item[:controller], item[:icon] ]
    end
  end

  def navigation_active?(controller)
    controller_name == controller
  end

  def navigation_icon(name)
    paths = {
      "dashboard" => [ "M3 3h7v7H3z", "M14 3h7v4h-7z", "M14 10h7v11h-7z", "M3 14h7v7H3z" ],
      "students" => [ "M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2", "M10 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z", "M20 21v-2a4 4 0 0 0-3-3.87", "M16 3.13a4 4 0 0 1 0 7.75" ],
      "courses" => [ "M4 19.5A2.5 2.5 0 0 1 6.5 17H20", "M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" ],
      "units" => [ "M4 4h16v16H4z", "M8 8h8", "M8 12h8", "M8 16h5" ],
      "enrolments" => [ "M9 11l3 3L22 4", "M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" ],
      "results" => [ "M3 3v18h18", "M18 17V9", "M13 17V5", "M8 17v-3" ]
    }

    tag.svg(viewBox: "0 0 24 24", fill: "none", stroke: "currentColor", stroke_width: "1.7", stroke_linecap: "round", stroke_linejoin: "round", aria: { hidden: true }, focusable: "false", class: "nav-icon") do
      safe_join(paths.fetch(name, []).map { |path| tag.path(d: path) })
    end
  end
end

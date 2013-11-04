class GoogleParser
  require "mechanize"

  PAGES_COUNT = 10
  def initialize(terms, page_count = nil)
    @pages_count = page_count || PAGES_COUNT
    @terms = terms
    @mech = Mechanize.new
    @titles = []
  end

  def visit_google_page
    @page = @mech.get("http://google.com")
  end

  def search_query
    form = @page.form('f')
    form.q = @terms
    @page = @mech.submit(form, form.buttons.first)
  end

  def visit_first_page
    visit_google_page
    search_query
    @current_page = 1
  rescue Mechanize::ResponseCodeError => e
    puts "Sorry, but probably google detected a bot and need captcha"
    puts e
  end

  def parse_page
    @titles += @page.search("h3.r").map(&:text)
  end

  def show_titles
    puts @titles.sort{ |a, b|  b[0].downcase <=> a[0].downcase }
  end

  def parse_first_page
    visit_first_page
    parse_page
  end

  def next_link
    @next_link = @page.links_with(class: "fl").find{ |link| link.text.to_i == @current_page + 1 }
  end

  def go_to_next_page
    @page = next_link.click
    @current_page += 1
  end

  def parse_next_pages
    2.upto @pages_count do
      return unless next_link
      go_to_next_page
      parse_page
    end
  end

  def parse
    parse_first_page
    parse_next_pages
  end

end
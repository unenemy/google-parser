require "./google_parser"
class ParserRunner
  def initialize
    get_terms
    get_pages
    init_parser
    run_parser
    show_results
  end

  def get_terms
    puts "please input searched terms"
    @terms = gets.chomp
  end

  def get_pages
    puts "please input pages count default count is #{GoogleParser::PAGES_COUNT}"
    input = gets.chomp
    @pages_count = input.empty? ? nil : input.to_i
  end

  def init_parser
    @parser = GoogleParser.new(@terms, @pages_count)
  end

  def run_parser
    @parser.parse
  end

  def show_results
    @parser.show_titles
  end
end

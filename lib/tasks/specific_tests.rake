# http://mentalized.net/journal/2006/07/28/run_specific_tests_via_rake/
#  by Geoffrey Grosenbach
#  modified by Jakob Skjerning and Bob Lail

# Run specific tests or test files
# 
# rake test:blog
# => Runs the full BlogTest unit test
# 
# rake test:blog:create
# => Runs the tests matching /create/ in the BlogTest unit test
# 
# rake test:blog_controller
# => Runs all tests in the BlogControllerTest functional test
# 
# rake test:blog_controller:create
# => Runs the tests matching /create/ in the BlogControllerTest functional test
#
rule "" do |t|
  if /^test:(.*)(:([^.]+))?$/.match(t.name) # test:file:method
    arguments = t.name.split(":")[1..-1] # skip test:
    file_pattern = arguments.shift
    test_pattern = arguments.shift
    file_name = "#{file_pattern}_test.rb"
    
    # the following works but it doesn't seem I can run multiple files with the -n switch
=begin
    rake_test_loader = Gem.find_files('rake/rake_test_loader.rb')
    tests = Dir.glob('test/**/*_test.rb').select{|file| file.match(file_name)}
    if tests.empty?
      puts "no test was found with the file name \"#{file_name}\""
    else
      sh "ruby -Ilib:test \"#{rake_test_loader}\" #{tests.join(' ')}"
    end
=end
    
    test = Dir.glob("test/**/#{file_name}").first
    if test.nil?
      puts "no test was found with the file name \"#{file_name}\""
    else
      # sh "ruby -Ilib:test \"#{rake_test_loader}\" #{test} #{"-n /#{test_pattern}/" if test_pattern}"
      sh "ruby -Ilib:test #{test} #{"-n /#{test_pattern}/" if test_pattern}"
    end
  end
end
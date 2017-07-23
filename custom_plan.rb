require 'zeus/parallel_tests'

class CustomPlan < Zeus::ParallelTests::Rails
  def test(*args)
    ENV['GUARD_RSPEC_RESULTS_FILE'] = 'tmp/guard_rspec_results.txt' # can be anything matching Guard::RSpec :results_file option in the Guardfile
    super
  end
end

Zeus.plan = CustomPlan.new

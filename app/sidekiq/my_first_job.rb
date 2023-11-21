class MyFirstJob
  include Sidekiq::Job

  def perform(name, age)
    puts "I am #{name}, running my first job at #{age}"
    #any other valid Ruby/Rails code goes here!
  end
end
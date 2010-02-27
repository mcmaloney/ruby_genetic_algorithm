# TODO:
#
# 1. Make the 'nix_upper_half' function smarter. Cut on an average? Use a STDEV into the good ones? Work a regression in somehow?
# 2. Make the mutation rate slow down as it starts to converge. Getting some oscillation as we get close to convergence probably because that rate's always the same.
# 3. Try to decompose the 'mate' function a little more. Seems like it's doing too much.
# 4. Roll 'make_next_gen' into 'mate'? Have to remove it from ga_run's loop if you do this.

module GA
  POPSIZE = 2048
  MUTATION_THRESH = 100
  MUTATION_OFFSET = 25
  TARGET  = "Michael C. Maloney"
  
  ######################################
  # CLASSES
  ######################################
  
  class Citizen
    attr_accessor :str, :fitness
    
    def initialize(str="", fitness=0)
      @str = str
      @fitness = fitness
    end
    
    # Build citizen objects that replicate the target object's length.
    def self.build
      c = self.new 
      for i in 0..TARGET.size - 1 
        c.str += (rand(90) + 32).chr
      end
      c
    end  
    
    # Insert a random character at a random point in the string.
    def mutate
      if (rand(MUTATION_THRESH) - MUTATION_OFFSET) > MUTATION_THRESH / 2
        self.str[rand(self.str.size)] = (rand(90) + 32).chr
      end
    end
  end
  
  class Population
    attr_accessor :citizens
    
    def initialize(citizens=[])
      @citizens = citizens
    end
  end
  
  ######################################
  # GA MODULE CLASS METHODS
  ######################################
  
  def self.init_population
    @population = Population.new
    POPSIZE.times do
      @population.citizens << Citizen.build
    end
  end
  
  def self.population
    @population
  end
  
  def self.calc_fitness
    for i in 0..POPSIZE - 1
      fitness = 0
      for j in 0..TARGET.size - 1
        fitness += (@population.citizens[i].str[j] - TARGET[j]).abs
      end
      @population.citizens[i].fitness = fitness
    end
  end
  
  def self.sort_by_fitness
    @population.citizens.sort! { |a, b| a.fitness <=> b.fitness }
  end
  
  # Will eventually use this to make the 'nix_upper_half' function a little smarter.
  def self.calc_fitness_avg
    x = 0
    @population.citizens.each do |citizen|
      x += citizen.fitness
    end
    x / @population.citizens.size
  end
  
  def self.nix_upper_half
    @survivors = []
    for i in 0..((@population.citizens.length - 1) / 2)
      @survivors << @population.citizens[i]
    end
  end
  
  # How can this be decomposed?
  def self.mate
    @children = []
    while @children.length < POPSIZE
      parent_a = @survivors[rand(@survivors.length)]
      parent_b = @survivors[rand(@survivors.length)]
      child = Citizen.new
      child.str += parent_a.str[0..((parent_a.str.size / 2)-1)]
      child.str += parent_b.str[(parent_b.str.size/2)..(parent_b.str.size - 1)]
      # mutate child's str at small random interval
      child.mutate
      children << child
    end
    @children
  end
  
  def self.children
    @children
  end
  
  # Maybe roll this into the end of the 'mate' function?
  def self.make_next_gen
    @population.citizens = @children
  end
    
  def self.print_best
    puts "Best Option: #{@population.citizens[0].str} (#{@population.citizens[0].fitness})"
  end 
end
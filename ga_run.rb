require 'ga'

def start_it
  GA.init_population
  GA.calc_fitness
  GA.sort_by_fitness
end

def loop_it
  while GA.population.citizens[0].fitness != 0
    GA.nix_upper_half
    GA.mate
    GA.make_next_gen
    GA.calc_fitness
    GA.sort_by_fitness
    GA.print_best
  end
end
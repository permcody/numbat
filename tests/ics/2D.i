# Density-driven convective mixing
# Test the initial condition

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 1000
  ny = 2
  xmax = 10
[]

[Variables]
  [./concentration]
    [./InitialCondition]
      type = NumbatPerturbationIC
      variable = concentration
      amplitude = 0.5
      seed = 0
    [../]
  [../]
[]

[Executioner]
  type = Transient
  end_time = 2
  start_time = 1
  solve_type = PJFNK
[]

[Problem]
  type = FEProblem
  solve = False
[]

[VectorPostprocessors]
  [./conc]
    type = NodalValueSampler
    variable = concentration
    sort_by = id
    execute_on = initial
  [../]
[]

[Outputs]
  perf_graph = true
  [./csvoutput]
    type = CSV
    file_base = 2D
    execute_on = 'INITIAL'
  [../]
[]

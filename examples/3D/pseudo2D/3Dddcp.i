# Density-driven convective mixing in a 3D representation of a 2D model. Only a single element is
# used in the y direction.
#
# Note: This example may take some time to run. At least 8 processors are recommended.

[Mesh]
  type = GeneratedMesh
  dim = 3
  xmax = 1000
  zmin = -200
  zmax = 0
  nx = 80
  nz = 20
  ymax = 1
  ny = 1
  bias_z = 0.7
[]

[Adaptivity]
  marker = combomarker
  max_h_level = 1
  initial_marker = boxmarker
  initial_steps = 1
  [./Indicators]
    [./gradjumpindicator]
      type = GradientJumpIndicator
      variable = concentration
    [../]
  [../]
  [./Markers]
    [./errormarker]
      type = ErrorToleranceMarker
      refine = 0.005
      indicator = gradjumpindicator
    [../]
    [./boxmarker]
      type = BoxMarker
      bottom_left = '0 0.0 -1.0'
      top_right = '1000 1 0'
      inside = refine
      outside = dont_mark
    [../]
    [./combomarker]
      type = ComboMarker
      markers = 'boxmarker errormarker'
    [../]
  [../]
[]

[Variables]
  [./concentration]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = NumbatPerturbationIC
      variable = concentration
      amplitude = 0.02
      seed = 1
    [../]
  [../]
  [./streamfunctionx]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  [../]
  [./streamfunctiony]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  [../]
[]

[Kernels]
  [./Darcy_x]
    type = NumbatDarcySF
    variable = streamfunctionx
    concentration = concentration
    component = x
  [../]
  [./Darcy_y]
    type = NumbatDarcySF
    variable = streamfunctiony
    concentration = concentration
    component = y
  [../]
  [./Convection]
    type = NumbatConvectionSF
    variable = concentration
    streamfunction = 'streamfunctionx streamfunctiony'
  [../]
  [./CDiffusion]
    type = NumbatDiffusionSF
    variable = concentration
  [../]
  [./TimeDerivative]
    type = TimeDerivative
    variable = concentration
  [../]
[]

[AuxVariables]
  [./u]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./v]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./w]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./uAux]
    type = NumbatDarcyVelocitySF
    variable = u
    component = x
    streamfunction = 'streamfunctionx streamfunctiony'
  [../]
  [./vAux]
    type = NumbatDarcyVelocitySF
    variable = v
    component = y
    streamfunction = 'streamfunctionx streamfunctiony'
  [../]
  [./wAux]
    type = NumbatDarcyVelocitySF
    variable = w
    component = z
    streamfunction = 'streamfunctionx streamfunctiony'
  [../]
[]

[BCs]
  [./conctop]
    type = DirichletBC
    variable = concentration
    boundary = front
    value = 1.0
  [../]
  [./streamfunxtop]
    type = DirichletBC
    variable = streamfunctionx
    boundary = front
    value = 0.0
  [../]
  [./streamfunxbottom]
    type = DirichletBC
    variable = streamfunctionx
    boundary = back
    value = 0.0
  [../]
  [./streamfunytop]
    type = DirichletBC
    variable = streamfunctiony
    boundary = front
    value = 0.0
  [../]
  [./streamfunybottom]
    type = DirichletBC
    variable = streamfunctiony
    boundary = back
    value = 0.0
  [../]
  [./Periodic]
    [./xy]
      variable = 'concentration streamfunctionx streamfunctiony'
      auto_direction = 'x y'
    [../]
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  dtmax = 100
  end_time = 2500
  start_time = 1
  solve_type = PJFNK
  petsc_options = -snes_ksp_ew
  nl_abs_tol = 1e-10
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    cutback_factor = 0.5
    growth_factor = 2
  [../]
  [./TimeIntegrator]
    type = LStableDirk2
  [../]
[]

[Postprocessors]
  [./boundaryfluxint]
    type = NumbatSideFluxSF
    variable = concentration
    boundary = front
  [../]
  [./numdofs]
    type = NumDOFs
  [../]
[]

[Outputs]
  [./console]
    type = Console
    perf_log = true
    output_nonlinear = true
    output_linear = true
  [../]
  [./exodus]
    type = Exodus
    file_base = 3Dddcp
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
  [./csvoutput]
    type = CSV
    file_base = 3Dddcp
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
[]
# Numerical Analysis: Drone Trajectory and Satellite Orbit

Group project for the course *Análise Numérica* (Numerical Analysis), Applied Mathematics
and Computation (LMAC), Instituto Superior Técnico, October 2025. Implemented in
**MATLAB**. The report is written in Portuguese.

The project has two parts: reconstructing the path and velocity of a drone from noisy GPS
data, and solving the differential equations of a satellite orbit with several numerical
methods.

## Part 1: Drone

### 1.1 Trip planning

- **Cubic spline interpolation** (`pergunta_1_1_1.m`): the path of the drone through 10 key
  points is built with natural cubic splines, with zero velocity at the start and end. The
  second-derivative system is solved for each coordinate, giving a smooth path with
  continuous position, velocity and acceleration.
- **Least-squares surface fit** (`pergunta_1_1_2.m`): a polynomial `p(x, y)` of degree ≤ 3
  is fitted by least squares over two regions, using a weight function. The normal
  equations are assembled from double integrals and solved as a linear system. The report
  shows that the solution is a minimum, because the Hessian is positive definite.

### 1.2 The trip: filtering noisy GPS data

- **Regularizing filter:** the function `g_ε(x) = (1/ε) g(x/ε)`, built from a piecewise
  cubic kernel, is proved to be a mollifier (non-negative, symmetric, compact support,
  integral equal to 1) and is used to remove the noise from the GPS measurements.
- **Filtered positions** (`pergunta_1_2_3.m`): discrete convolution with normalization
  (ε = 1), followed by linear interpolation. Results are compared with the raw data in 2D
  and 3D.
- **Velocity from the filtered data** (`pergunta_1_2_4.m`, `derivada_filtrada.m`): the
  derivative of the position is approximated by convolving with `g'_ε` and using the
  trapezoidal rule.
- **Second derivative** (`pergunta_1_2_5.m`): a fourth-order finite-difference formula with
  5 nodes is derived with Taylor expansions:

  `x''(t) ≈ [-x(t-2h) + 16x(t-h) - 30x(t) + 16x(t+h) - x(t+2h)] / (12h²)`

  The report shows why the formula fails at the nodes of a piecewise linear function, and
  derives the step size `h` that minimizes the error bound (`h⁶ = 2M / (3C)`).

### Main results

| Quantity | Result |
|----------|--------|
| Velocity at t = 5 s | (3.763, 2.4345, 4.2585) m/s |
| Speed at t = 5 s | ≈ 6.18 m/s, below the 10 m/s limit |
| Second derivative x''(5) | ≈ 4.95872 |

## Part 2: Satellite

The orbit of a satellite is a system of four first-order ODEs (planar restricted
three-body problem, μ = 0.012277471), solved over three orbital periods.

- **Explicit Euler** (`eulerexp.m`, `pergunta_2_1.m`): reconstructs three periods of the
  orbit.
- **Order of convergence** (`heun.m`, `RK4.m`, `ordens.m`, `pergunta_2_2.m`): the orders
  of Euler, Heun and Runge-Kutta 4 are estimated numerically, using `ode45` as the
  reference solution.

  | Method | h = 0.001 | h = 0.0005 | h = 0.00025 | h = 0.000125 | Expected order |
  |--------|-----------|------------|-------------|--------------|----------------|
  | Euler | 1.0750 | 0.8674 | 0.9669 | 0.9980 | 1 |
  | Heun | 2.1725 | 2.0923 | 2.0362 | 2.0153 | 2 |
  | RK4 | 4.1926 | 4.1171 | 4.0642 | 4.0338 | 4 |

- **Sensitivity to perturbations** (`pergunta_2_3.m`): the initial condition
  `x₁(0) = 0.994 + ε` is perturbed with ε between 1e-5 and 5e-4. On one period the problem
  looks stable (the distance shrinks with ε), but on three periods the smallest
  perturbation gives the largest deviation, so stability in the Lyapunov sense is not
  observed.

## Requirements

- MATLAB [version]
- No extra toolboxes [confirm, or list them]

## How to run

Each exercise has its own script. Open MATLAB in the project folder and run, for example:

```matlab
>> pergunta_1_1_1     % drone path with cubic splines
>> pergunta_1_2_3     % filtered GPS data
>> pergunta_2_2       % orders of convergence
```

## Repository structure

```
pergunta_1_1_1.m       Cubic spline path of the drone
pergunta_1_1_2.m       Least-squares polynomial fit
pergunta_1_2_2.m       Plots of the filter and of the normal distribution
pergunta_1_2_3.m       Filtering of the GPS data
pergunta_1_2_4.m       Velocity from filtered data
derivada_filtrada.m    Derivative by convolution and quadrature
pergunta_1_2_5.m       Finite-difference formula for the second derivative
pergunta_2_1.m         Satellite orbit with explicit Euler
eulerexp.m             Explicit Euler method
heun.m                 Heun method
RK4.m                  Runge-Kutta method of order 4
ordens.m               Numerical order of convergence
pergunta_2_2.m         Convergence table
pergunta_2_3.m         Perturbation study
report/                Project report (PDF, in Portuguese)
```



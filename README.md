# OutlierDetectionTest

[![Documentation (stable)](https://img.shields.io/badge/docs-stable-blue.svg)](https://OutlierDetectionJL.github.io/OutlierDetection.jl/stable)
[![Documentation (dev)](https://img.shields.io/badge/docs-dev-blue.svg)](https://OutlierDetectionJL.github.io/OutlierDetection.jl/dev)
[![Build Status](https://github.com/OutlierDetectionJL/OutlierDetectionTest.jl/workflows/CI/badge.svg)](https://github.com/OutlierDetectionJL/OutlierDetectionTest.jl/actions)

This package provides basic tests for `OutlierDetection.jl` models. Simply add `OutlierDetectionTest` to your test dependencies and start testing!

```julia
using OutlierDetectionTest

data = TestData()
test_detector(MY_DETECTOR, data)
```

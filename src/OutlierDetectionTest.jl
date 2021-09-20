module OutlierDetectionTest
    using Test
    using OutlierDetection
    using Random:MersenneTwister

    import OutlierDetectionInterface
    const OD = OutlierDetectionInterface

    import MLJBase
    const MLJ = MLJBase

    export TestData, test_detector, test_meta

    include("generate_data.jl")
    include("test_detector.jl")
    include("test_meta.jl")
end

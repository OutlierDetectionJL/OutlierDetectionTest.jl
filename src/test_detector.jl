function test_detector(detector::OD.Detector, data::TestData)
    @testset "$detector" begin
        is_supervised = isa(detector, OD.SupervisedDetector)

        # OutlierDetection detector with matrix input
        raw_model, raw_train = is_supervised ?
            OD.fit(detector, data.x_raw[:, data.train_idx], data.y_cat[data.train_idx]; verbosity=0) :
            OD.fit(detector, data.x_raw[:, data.train_idx]; verbosity=0)
        raw_test = OD.transform(detector, raw_model, data.x_raw[:, data.test_idx])

        # MLJ plain detector with table input
        mlj_raw = is_supervised ? MLJ.machine(detector, data.x_table, data.y_cat) :
                                  MLJ.machine(detector, data.x_table)
        MLJ.fit!(mlj_raw, rows=data.train_idx)
        mlj_raw_train = MLJ.report(mlj_raw).scores
        mlj_raw_test = MLJ.transform(mlj_raw, rows=data.test_idx)

        # MLJ probabilistic detector with table input
        mlj_prob = is_supervised ? MLJ.machine(ProbabilisticDetector(detector), data.x_table, data.y_cat) :
                                   MLJ.machine(ProbabilisticDetector(detector), data.x_table)
        MLJ.fit!(mlj_prob, rows=data.train_idx)
        mlj_prob_train = MLJ.report(mlj_prob).detector.scores
        mlj_prob_test = from_univariate_finite(MLJ.predict(mlj_prob, rows=data.test_idx))

        # MLJ deterministic detector with table input
        mlj_det = is_supervised ? MLJ.machine(DeterministicDetector(detector), data.x_table, data.y_cat) :
                                  MLJ.machine(DeterministicDetector(detector), data.x_table)
        MLJ.fit!(mlj_det, rows=data.train_idx)
        mlj_det_train = MLJ.report(mlj_det).detector.scores
        mlj_det_test = from_categorical(MLJ.predict(mlj_det, rows=data.test_idx))

        @testset "outputs have appropriate dimensions" begin
            @test length(raw_train) ==
                  length(mlj_raw_train) ==
                  length(mlj_prob_train) ==
                  length(mlj_det_train) ==
                  data.n_train

            @test length(raw_test) ==
                  length(mlj_raw_test) == 
                  length(mlj_prob_test) ==
                  length(mlj_det_test) ==
                  data.n_test
        end

        @testset "raw scores have appropriate values" begin
            @test all(-Inf .< raw_train .< Inf)
            @test all(-Inf .< mlj_raw_train .< Inf)
            @test all(-Inf .< mlj_prob_train .< Inf)
            @test all(-Inf .< mlj_det_train .< Inf)
            @test all(-Inf .< raw_test .< Inf)
            @test all(-Inf .< mlj_raw_test .< Inf)
        end

        @testset "normalized scores have appropriate values" begin
            @test all(0 .<= mlj_prob_test .<= 1)
        end

        @testset "labels have appropriate values" begin
            in_labels(x) = x in (OutlierDetection.CLASS_NORMAL, OutlierDetection.CLASS_OUTLIER)
            @test all(in_labels.(mlj_det_test))
        end
    end
end

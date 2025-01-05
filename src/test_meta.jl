function test_meta(detector_type::Type{<:OD.Detector})
    @testset "$detector_type @meta" begin
        @testset "the detector `metadata_pkg` is defined" begin
            @test MLJ.package_name(detector_type) != "unknown"
            @test MLJ.package_uuid(detector_type) != "unknown"
            @test MLJ.package_url(detector_type) != "unknown"
        end

        @testset "the detector `load_path` is defined on the module top-level" begin
            @test MLJ.load_path(detector_type) != "unknown"
        end
    end
end

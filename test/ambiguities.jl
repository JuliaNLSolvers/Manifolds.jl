@testset "Ambiguities" begin
    if VERSION.prerelease == () && !Sys.iswindows() && VERSION < v"1.7.0"
        mbs = Test.detect_ambiguities(ManifoldsBase)
        # Interims solution until we follow what was proposed in
        # https://discourse.julialang.org/t/avoid-ambiguities-with-individual-number-element-identity/62465/2
        fmbs = filter(x -> !any(has_type_in_signature.(x, Identity)), mbs)
        @test length(fmbs) == 0
        ms = Test.detect_ambiguities(Manifolds)
        # Interims solution until we follow what was proposed in
        # https://discourse.julialang.org/t/avoid-ambiguities-with-individual-number-element-identity/62465/2
        fms = filter(x -> !any(has_type_in_signature.(x, Identity)), ms)
        @test length(fms) == 0
        # this test takes way too long to perform regularly
        # @test length(our_base_ambiguities()) <= 24
    else
        @info "Skipping Ambiguity tests for pre-release versions"
    end
end
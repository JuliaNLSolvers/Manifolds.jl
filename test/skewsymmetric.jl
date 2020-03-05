include("utils.jl")

@testset "SkewSymmetricMatrices" begin
    M=SkewSymmetricMatrices(3,ℝ)
    A = [1 2 3; 4 5 6; 7 8 9]
    A_skewsym = [0 -2 -3; 2 0 1; 3 -1 0]
    A_skewsym2 = [0 -2 -3; 2 0 1; 3 -1 0]
    B_skewsym = [0 -2 -3; 2 0 -1; 3 1 0]
    M_complex = SkewSymmetricMatrices(3,ℂ)
    @test repr(M_complex) == "SkewSymmetricMatrices(3, ℂ)"
    C = [0 -1 im; 1 0 -im; im -im 0]
    D = [1 0; 0 1];
    X = zeros(3,3)
    @testset "Real Skew-Symmetric Matrices Basics" begin
        @test repr(M) == "SkewSymmetricMatrices(3, ℝ)"
        @test representation_size(M) == (3,3)
        @test base_manifold(M) === M
        @test typeof(get_embedding(M)) === Euclidean{Tuple{3,3},ℝ}
        @test check_manifold_point(M,B_skewsym) === nothing
        @test_throws DomainError is_manifold_point(M,A,true)
        @test_throws DomainError is_manifold_point(M,C,true)
        @test_throws DomainError is_manifold_point(M,D,true)
        @test_throws DomainError is_manifold_point(M_complex, [:a :b :c; :b :d :e; :c :e :f],true)
        @test check_tangent_vector(M,B_skewsym,B_skewsym) === nothing
        @test_throws DomainError is_tangent_vector(M,B_skewsym,A,true)
        @test_throws DomainError is_tangent_vector(M,A,B_skewsym,true)
        @test_throws DomainError is_tangent_vector(M,B_skewsym,D,true)
        @test_throws DomainError is_tangent_vector(M,B_skewsym, 1*im * zero_tangent_vector(M,B_skewsym),true)
        @test_throws DomainError is_tangent_vector(M_complex, B_skewsym, [:a :b :c; :b :d :e; :c :e :f],true)
        @test manifold_dimension(M) == 3
        @test manifold_dimension(M_complex) == 9
        @test A_skewsym2 == project_point!(M, A_skewsym, A_skewsym)
        @test A_skewsym2 == project_tangent(M, A_skewsym, A_skewsym)
        A_sym3 = similar(A_skewsym)
        embed!(M,A_sym3, A_skewsym)
        A_sym4 = embed(M,A_skewsym)
        @test A_sym3 == A_skewsym
        @test A_sym4 == A_skewsym
    end
    types = [
        Matrix{Float64},
        MMatrix{3,3,Float64},
        Matrix{Float32},
    ]
    bases = (ArbitraryOrthonormalBasis(), ProjectedOrthonormalBasis(:svd))
    for T in types
        pts = [convert(T,A_skewsym),convert(T,B_skewsym),convert(T,X)]
        @testset "Type $T" begin
            test_manifold(
                M,
                pts,
                test_injectivity_radius = false,
                test_reverse_diff = isa(T, Vector),
                test_project_tangent = true,
                test_musical_isomorphisms = true,
                test_vector_transport = true,
                basis_types_vecs = (DiagonalizingOrthonormalBasis(log(M, pts[1], pts[2])), bases...),
                basis_types_to_from = bases,
            )
            test_manifold(
                M_complex,
                pts,
                test_injectivity_radius = false,
                test_reverse_diff = isa(T, Vector),
                test_project_tangent = true,
                test_musical_isomorphisms = true,
                test_vector_transport = true,
                basis_types_vecs = (ArbitraryOrthonormalBasis(),),
                basis_types_to_from = (ArbitraryOrthonormalBasis(),)
            )
            @test isapprox(-pts[1], exp(M, pts[1], log(M, pts[1], -pts[1])))
        end # testset type $T
    end # for
end # test SymmetricMatrices
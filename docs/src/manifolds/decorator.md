# Decorator manifold

A decorator manifold extends the functionality of a [`Manifold`](@ref) is a transparent way.
It internally stores the [`Manifold`](@ref) it extends and for all usual functions
defined in the [`ManifoldsBase`](interface.md), acts by default transparent in the sense that it passes all functions through to the base despite those that it actually affects.
For example the [`ArrayManifold`](@ref) directly overwrites nearly all functions, since it affects nearly all functions, despite a few like [`manifold_dimension`](@ref). On the other hand, the [`MetricManifold`](@ref) only affects functions
that involve metrics, especially [`exp`](@ref) and [`log`](@ref) but not the [`manifold_dimension`](@ref).

By default all functions are passed down. To implement a function for a decorator
different from the internal manifold, two steps are required. Let's assume the function is called `f(M,arg1,arg2)`, and our decorator manifold is `DM` that decorates `M`. Then

1. set `decorator_transparent_dispatch(f,M) = false`
2. implement `f(DM,arg1,arg2)`

Notw that by setting a `default_decorator_dispatch` function for your type, which is set to `is_default_metric` in our example manifold, you can still set the default matric to fall back to `f(M, arg1, args2)` even if the decorator is set to be nontransparent by step 1.
This makes it possible to extend a manifold or all manifolds with a feature, where the original implementation already covers one specific case. The [`MetricManifold`](@ref) is the best example, since the default metric indicates, for which metric the manifold was originally implemented, such that those functions are just passed through.
This can best be seen in the [`SymmetricPositiveDefinite`](@ref) manifold with its [`LinearAffineMetric`](@ref).
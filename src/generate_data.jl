struct TestData
    x_raw
    x_table
    y_raw
    y_cat
    n_train
    n_test
    train_idx
    test_idx

    function TestData(;rng=MersenneTwister(0), fraction_train=0.5, n_samples=100, n_dim=10)
        X_raw = rand(rng, n_dim, n_samples)
        X_table = MLJ.table(collect(X_raw'))
        y_raw = rand(rng, (CLASS_NORMAL, CLASS_OUTLIER), n_samples)
        y_cat = to_categorical(y_raw)
        train, test  = MLJ.partition(eachindex(y_cat), fraction_train, rng=rng);
        n_train = Int(n_samples * fraction_train)
        n_test = n_samples - n_train

        new(X_raw, X_table, y_raw, y_cat, n_train, n_test, train, test)
    end
end

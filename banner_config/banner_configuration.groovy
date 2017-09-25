onLineHelp.url = "http://HOST:PORT/banner9OH"
banner.transactionTimeout = 30
bannerDataSource {

    // JNDI configuration for use in 'production' environment
    jndiName = "jdbc/bannerDataSource"

    // Local configuration for use in 'development' and 'test' environments
    url   = "jdbc:oracle:thin:@HOST:PORT:SID"

    username = "USERNAME"
    password = "PASSWORD"
    driver   = "oracle.jdbc.OracleDriver"

}

bannerSsbDataSource {

    // JNDI configuration for use in 'production' environment
    //
    jndiName = "jdbc/bannerSsbDataSource"

    // Local configuration for use in 'development' and 'test' environments
    //
    url   = "jdbc:oracle:thin:@HOST:PORT:SID"

    username = "USERNAME"
    password = "PASSWORD"
    driver   = "oracle.jdbc.OracleDriver"
}
